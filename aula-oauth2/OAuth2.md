# Roteiro de Trabalho: Princípios Básicos de Autorização com OAuth 2.0 e JWT

---

## Introdução ao JWT (JSON Web Token)

O **JWT (JSON Web Token)** é um padrão aberto (RFC 7519) que define uma forma compacta e autossuficiente de transmitir informações entre partes de forma segura, utilizando objetos JSON. Ele é amplamente usado em sistemas de autenticação e autorização, especialmente em APIs REST e fluxos OAuth2, por sua eficiência e capacidade de armazenar dados verificáveis sem necessidade de armazenamento em servidor (*stateless*).

---

### Estrutura do JWT

Um JWT é composto por três partes, separadas por pontos (`.`):

1. **Header (Cabeçalho)**:  
   Define o algoritmo de assinatura (ex: HS256, RS256) e o tipo do token (`"typ": "JWT"`). Exemplo:

   ```json
   {
     "alg": "HS256",
     "typ": "JWT"
   }
   ```

   *Codificado em Base64Url*.

2. **Payload (Carga útil)**:  
   Contém as **claims** (reivindicações), que são informações sobre o usuário e metadados. Exemplo:

   ```json
   {
     "sub": "1234567890",
     "name": "João Silva",
     "exp": 1690258153
   }
   ```

   - **Claims padrão**: `sub` (assunto), `exp` (expiração), `iss` (emissor), `aud` (público-alvo).  
   - **Claims personalizadas**: Podem ser adicionadas conforme necessidade (ex: `roles` para permissões).  

3. **Signature (Assinatura)**:  
   Garante a integridade do token. É gerada combinando o header, o payload e uma chave secreta (ou par de chaves pública/privada). Exemplo de assinatura HMAC-SHA256:

   ```
   HMACSHA256(base64UrlEncode(header) + "." + base64UrlEncode(payload), chave_secreta)
   ```

---

### **Funcionamento em Sistemas de Autenticação**

1. **Geração do Token**:  
   Após a autenticação (ex: login com OAuth2), o servidor gera um JWT assinado e o envia ao cliente.

2. **Armazenamento no Cliente**:  
   O token é geralmente armazenado em cookies HTTP-only ou no `localStorage` do navegador.

3. **Envio em Requisições**:  
   O cliente inclui o JWT no cabeçalho `Authorization` das requisições subsequentes:

   ```
   Authorization: Bearer 
   ```

4. **Validação pelo Servidor**:  
   O servidor verifica a assinatura, a expiração e as claims para autorizar o acesso.

---

### **Vantagens do JWT**

- **Stateless**: Não requer armazenamento de sessão no servidor, reduzindo carga e facilitando escalabilidade.
- **Portabilidade**: Pode ser usado em diferentes sistemas (APIs, microsserviços) e linguagens.
- **Segurança**: Assinatura digital previne adulteração.
- **Flexibilidade**: Claims personalizáveis permitem transmitir dados contextuais [ex: permissões].

---

### **Integração com Spring Security**

No contexto do Spring Security, o JWT é frequentemente usado com a biblioteca `jjwt` para geração/validação de tokens e o `spring-security-oauth2-resource-server` para proteção de endpoints. Exemplo de configuração:

```java
@Bean
public JwtDecoder jwtDecoder() {
    return NimbusJwtDecoder.withPublicKey(publicKey).build();
}
```

Essa configuração permite que o Spring valide automaticamente tokens JWT em requisições, extraindo claims para autorização[2][5][8].

---

## Introdução ao OAuth 2.0

**OAuth 2.0** é um protocolo de autorização que permite que aplicativos de terceiros acessem recursos protegidos em nome de um usuário, sem a necessidade de compartilhar credenciais.

### Funções no OAuth 2.0

1. **Cliente**: Aplicação que solicita acesso a recursos (ex.: app web).
2. **Proprietário do Recurso (Resource Owner)**: Usuário que concede permissão.
3. **Servidor de Autorização (Authorization Server)**: Emite tokens após autenticação (ex.: Google, Auth0).
4. **Servidor de Recurso (Resource Server)**: Hospeda os recursos protegidos (ex.: API do Google Drive).

### Tokens no OAuth 2.0

- **Token de Acesso (Access Token)**  
  Credencial usada para acessar recursos protegidos. Tem vida curta (minutos/horas).
- **Token de Atualização (Refresh Token)**  
  Usado para obter novos access tokens sem reautenticação. Armazenado com segurança no cliente.
- **Código de Autorização (Authorization Code)**  
  Código temporário trocado por tokens após redirecionamento (evita exposição direta de tokens no frontend).

### Tipos de Concessão (Grant Types)

| Tipo                   | Uso Recomendado                      | Segurança |
|------------------------|--------------------------------------|-----------|
| **Authorization Code** | Aplicações web/server-side           | Alta      |
| **Implicit**           | SPAs (obsoleto, substituído por PKCE)| Baixa     |
| **Client Credentials** | Comunicação servidor-servidor        | Média     |
| **Password**           | Legacy (não recomendado)             | Baixa     |

### Aspectos Críticos para Desenvolvedores

- **Parâmetro `state`**: Previne *Cross-Site Reference Forgery* (CSRF) em fluxos OAuth. Deve ser único e validado no retorno.
- **PKCE (*Proof Key for Code Exchange*)**: Obrigatório para clientes públicos (SPAs/mobile). Usa `code_verifier` e `code_challenge`.
- **Escopos (Scopes)**: Limita permissões do token (ex.: `read:contacts`).
- **Validação de Redirect URI**: Evita redirecionamentos maliciosos.
- **Armazenamento Seguro de Tokens**: HTTP-only cookies ou armazenamento seguro no mobile.

## Fluxo de Autorização com PKCE

O fluxo de autorização OAuth 2.0 com PKCE (Proof Key for Code Exchange) é uma extensão de segurança que protege especialmente aplicações que não podem manter um segredo do cliente seguro, como aplicações móveis e SPAs.

![Fluxo de autorização OAuth 2.0 com PKCE](auth-sequence-auth-code-pkce.png)

### Como PKCE funciona

1. O cliente gera um `code_verifier` aleatório
2. Deriva um `code_challenge` a partir do verifier usando SHA-256
3. Envia o `code_challenge` na solicitação de autorização
4. Quando troca o código por tokens, envia o `code_verifier` original
5. O servidor verifica se o `code_verifier` corresponde ao `code_challenge` original

Esta abordagem protege contra interceptação do código de autorização, mesmo em ambientes menos seguros.

---

## Estudo de caso: Spring Security e OAuth2**

### **Configuração do Ambiente**

**Ferramentas Necessárias**:

- **JDK 17+**: Java Development Kit para compilar e executar o projeto.
- **Spring Boot 3.3.1+**: Framework para desenvolvimento rápido de aplicações Java.
- **Maven**: Gerenciador de dependências e build.
- **Conta no Google Cloud**: Para registrar a aplicação como cliente OAuth2.

---

#### **Passo 1: Criar um Projeto Spring Boot**

Utilize o [Spring Initializr](https://start.spring.io/) com as seguintes configurações:

- **Project**: Maven
- **Language**: Java
- **Dependencies**:
  - `Spring Web` (para endpoints REST)
  - `Spring Security` (para autenticação/autorização)
  - `OAuth2 Client` (integração com provedores OAuth2)
  - `Thymeleaf` (para templates HTML)

---

#### **Passo 2: Adicionar Dependências no `pom.xml`**

```xml

    
    
        org.springframework.boot
        spring-boot-starter-oauth2-client
    
    
        org.springframework.boot
        spring-boot-starter-security
    
    
    
    
        org.springframework.boot
        spring-boot-starter-thymeleaf
    

```

**Explicação das Dependências**:

- **spring-boot-starter-oauth2-client**: Habilita autenticação via OAuth2 com provedores como Google, GitHub, etc.
- **spring-boot-starter-security**: Fornece mecanismos de segurança integrados (ex: CSRF, autorização).
- **spring-boot-starter-thymeleaf**: Permite renderizar páginas HTML dinâmicas.

---

#### **Passo 3: Configurar o `application.properties`**

```properties
# Credenciais do Google OAuth2 (obtidas no Google Cloud Console)
spring.security.oauth2.client.registration.google.client-id=SEU_CLIENT_ID
spring.security.oauth2.client.registration.google.client-secret=SEU_CLIENT_SECRET
spring.security.oauth2.client.registration.google.redirect-uri=http://localhost:8080/login/oauth2/code/google
spring.security.oauth2.client.registration.google.scope=profile,email

# Configuração básica
server.port=8080
```

**Termos e Propriedades**:

- **client-id/client-secret**: Credenciais únicas da aplicação registrada no Google Cloud.
- **redirect-uri**: URL para onde o Google redirecionará após a autenticação.
- **scope**: Permissões solicitadas (ex: `profile` para nome do usuário, `email` para endereço de e-mail).

---

#### **Passo 4: Criar a Classe de Configuração de Segurança**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(authorize -> authorize
                .requestMatchers("/", "/login").permitAll() // Público
                .anyRequest().authenticated() // Exige autenticação
            )
            .oauth2Login(oauth2 -> oauth2
                .loginPage("/login") // Página de login personalizada
                .defaultSuccessUrl("/home", true) // Redirecionamento pós-login
            );
        return http.build();
    }
}
```

**Funcionalidades**:

- **authorizeHttpRequests**: Define políticas de acesso (ex: `/home` requer autenticação).
- **oauth2Login**: Configura o fluxo OAuth2 com redirecionamento para o Google.

---

#### **Passo 5: Criar o Controlador para Páginas HTML**

```java
@Controller
public class HomeController {

    @GetMapping("/home")
    public String home(@AuthenticationPrincipal OAuth2User user, Model model) {
        model.addAttribute("nome", user.getAttribute("name")); // Obtém o nome do usuário
        return "home";
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }
}
```

**Explicação**:

- **@AuthenticationPrincipal**: Injeta os dados do usuário autenticado via OAuth2.
- **OAuth2User**: Objeto que contém atributos do perfil do usuário (ex: nome, e-mail).

---

#### **Passo 6: Criar Templates HTML com Thymeleaf**

**`login.html`**:

```html



    Login
    Login com Google


```

**`home.html`**:

```html



    Bem-vindo, !
    Você está autenticado via OAuth2.


```

---

#### **Passo 7: Registrar a Aplicação no Google Cloud**

1. Acesse o [Google Cloud Console](https://console.cloud.google.com/).
2. Crie um novo projeto e vá para **APIs e Serviços > Credenciais**.
3. Clique em **Criar Credenciais > ID do cliente OAuth**.
4. Preencha:
   - **Tipo de aplicação**: Aplicativo da Web
   - **URIs de redirecionamento autorizados**: `http://localhost:8080/login/oauth2/code/google`
5. Salve o **Client ID** e **Client Secret** no `application.properties`.

---

#### **Passo 8: Executar e Testar a Aplicação**

```bash
mvn spring-boot:run
```

Acesse `http://localhost:8080/login`, clique em "Login com Google" e autorize o acesso. Você será redirecionado para `/home`, onde verá seu nome.

---

#### **Explicação de Termos Técnicos**

- **OAuth2**: Protocolo de autorização que permite aplicações acessarem recursos de usuários sem expor senhas.
- **Spring Security**: Framework de segurança para controle de acesso e autenticação em aplicações Java.
- **Thymeleaf**: Motor de templates para renderizar HTML dinâmicos.
- **Client ID/Secret**: Credenciais únicas que identificam a aplicação perante o provedor OAuth2.

---

#### **Cenários de Segurança (Opcional)**

Para adicionar proteção contra ataques comuns:

1. **CSRF (Cross-Site Request Forgery)**: Habilitado por padrão no Spring Security.
2. **Validação de Estado**: O Spring Security OAuth2 inclui automaticamente o parâmetro `state` para prevenir ataques de redirecionamento.

---

**Resultado Final**:  
Aplicação Spring Boot integrada com OAuth2, permitindo login seguro via Google e exibição de dados do usuário.
