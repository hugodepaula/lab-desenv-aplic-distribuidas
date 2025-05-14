# 🧑‍🏫 Roteiro de Aula Prática: Containers com Docker, Dockerfile e Docker Compose usando Spring Boot + PostgreSQL

## 📌 Pré-requisitos
* Docker Desktop instalado com suporte ao BuildKit e docker buildx.
* Conta no Docker Hub (opcional para push).
* Editor de código (Visual Studio Code recomendado).
* Git instalado.

---

## 🧠 Parte 0: O que são Containers?

### 📈 Definição Formal

> **Container** é uma instância isolada de uma imagem que encapsula uma aplicação e todas as suas dependências, permitindo que ela seja executada de forma consistente em qualquer ambiente que tenha um container runtime (como o Docker Engine).

### 🔎 Características

* Isolamento de processos
* Portabilidade (funciona da mesma forma em qualquer lugar)
* Eficiência (usa o mesmo kernel do host)
* Inicialização rápida
* Controle de versões com imagens reproduzíveis

### 🔄 Principais ferramentas de containerização

| Ferramenta | Descrição                                                                     |
| ---------- | ----------------------------------------------------------------------------- |
| Docker     | Plataforma mais popular para criação, gerenciamento e execução de containers. |
| Podman     | Alternativa compatível com Docker CLI, sem daemon e com foco em segurança.    |
| LXC/LXD    | Soluções de containerização de sistema completo, gerenciadas pelo Linux.      |
| containerd | Runtime de containers usado como backend pelo Docker.                         |
| CRI-O      | Ferramenta otimizada para Kubernetes.                                         |

---


## 📁 Parte 1: Criando a Aplicação Spring Boot

### 🛠️ Gerando o Projeto

```bash
Acesse o site https://start.spring.io
add dependecy SpringWeb
unzip app-docker.zip
cd app-docker
```
![Projeto Spring](/versao-demo.png)


Edite o ```src/main/java/com/example/demo/DemoApplication.java:```


```java
package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;

@SpringBootApplication
@RestController
public class DemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}

	@GetMapping("/")
	public String home() {
		return "Hello from Spring Boot + Docker!";
	}

}

```

---

## 🐳 Parte 2: Containerizando com Dockerfile (sem Compose)


> **Imagem Docker** Snapshot imutável com tudo que a aplicação precisa para rodar (binários, bibliotecas, dependências, etc).

> **Dockerfile** Script declarativo para construir imagens. | Define o passo a passo automatizado para criar uma imagem Docker da aplicação


### 🔨 Etapa 2.1: Criando o Dockerfile

```Dockerfile
FROM maven:3.9.4-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### 🔍 Explicação de cada elemento:

| Instrução                           | Propósito                                                                                                  |
| ----------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `FROM maven:... AS build`           | Usa uma imagem base com Maven e JDK para compilar o código. O alias `build` permite reutilizar essa etapa. |
| `WORKDIR /app`                      | Define o diretório de trabalho dentro do container.                                                        |
| `COPY pom.xml .`                    | Copia o `pom.xml` para o container (ajuda no cache).                                                       |
| `COPY src ./src`                    | Copia o código-fonte para dentro do container.                                                             |
| `RUN mvn clean package -DskipTests` | Compila e empacota a aplicação.                                                                            |
| `FROM eclipse-temurin:...`          | Define uma imagem leve (Alpine) para rodar a aplicação Java.                                               |
| `COPY --from=build ...`             | Copia o JAR da etapa de build para o ambiente de execução.                                                 |
| `EXPOSE 8080`                       | Documenta que o container expõe a porta 8080.                                                              |
| `ENTRYPOINT [...]`                  | Comando padrão executado ao iniciar o container (roda o JAR).                                              |

> 🧠 **Boas práticas aplicadas:**
> * Imagens base pequenas (Alpine).
> * Multi-stage build para reduzir tamanho final.



### 🗂️ Etapa 2.2: Criando o .dockerignore

```
target/
.git/
*.log
```

### 🏗️ Etapa 2.3: Build da imagem

```bash
docker build -t app-docker .
```

| Componente      | Propósito                                                                                                    |
| --------------- | ------------------------------------------------------------------------------------------------------------- |
| `docker build`  | Comando para **construir uma imagem Docker** a partir do `Dockerfile`.                                        |
| `-t app-docker` | Define o nome (`tag`) da imagem como `app-docker`.                                                            |
| `.`             | Define o **contexto de build**, ou seja, o diretório onde está o `Dockerfile` e os arquivos a serem copiados. |


### 🚀 Etapa 2.4: Executar com docker run

```bash
docker run -p 8080:8080 app-docker
```

| Parâmetro      | Propósito                                                                                  |
| -------------- | ------------------------------------------------------------------------------------------ |
| `docker run`   | Cria e executa um novo container baseado em uma imagem.                                    |
| `-p 8080:8080` | Mapeia a porta 8080 do container para a porta 8080 do host (permite acesso via navegador). |
| `app-docker`   | Nome da imagem a ser executada.                                                            |

---

## ⚙️ Parte 3: Usando Docker Compose (com PostgreSQL)

> **docker-compose** Orquestra múltiplos containers com uma configuração declarativa (YAML), útil para ambientes com mais de um serviço.


Agora vamos orquestrar dois containers: o app e o banco PostgreSQL.

### 📀 3.1 Exemplo Spring Boot + PostgreSQL

```bash
Acesse o site https://start.spring.io
add dependecy Spring Web, Lombok, Spring Data JPA e Postgre Sql Drive
unzip app-docker.zip
cd app-docker
```
![Projeto Spring](/docker-compose.png)

#### 1. Entidade JPA

Crie uma pasta com nome `model`

```java
package com.example.demo.docker.compose.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
public class Usuario {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nome;

    public Usuario() {
    }

    public Usuario(String nome) {
        this.nome = nome;
    }
}

```

#### 2. Repositório

Crie uma pasta `repository`

```java
package com.example.demo.docker.compose.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.docker.compose.model.Usuario;

public interface UsuarioRepository extends JpaRepository<Usuario, Long> {
}
```

#### 3. Controlador REST

Crie a pasta `controller`

```java
package com.example.demo.docker.compose.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.docker.compose.model.Usuario;
import com.example.demo.docker.compose.repository.UsuarioRepository;

@RestController
@RequestMapping("/usuarios")
public class UsuarioController {
    private final UsuarioRepository repository;

    public UsuarioController(UsuarioRepository repository) {
        this.repository = repository;
    }

    @GetMapping
    public List<Usuario> listar() {
        return repository.findAll();
    }

    @PostMapping
    public Usuario salvar(@RequestBody Usuario usuario) {
        return repository.save(usuario);
    }
}

```

#### 4. Configuração application.properties

```properties
spring.datasource.url=${SPRING_DATASOURCE_URL}
spring.datasource.username=${SPRING_DATASOURCE_USERNAME}
spring.datasource.password=${SPRING_DATASOURCE_PASSWORD}
spring.jpa.hibernate.ddl-auto=update
```

---

### 📄 3.2 docker-compose.yml

Crie o arquivo `docker-compose.yml` na raiz do projeto.
Adicione os arquivos `Dockerfile` e `.dockerignore`

```yaml
version: '3.8'

services:
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: appdb
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - springnet

  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://db:5432/appdb
      SPRING_DATASOURCE_USERNAME: postgres
      SPRING_DATASOURCE_PASSWORD: postgres
    depends_on:
      - db
    networks:
      - springnet

volumes:
  postgres_data:

networks:
  springnet:
```


### 🔍 Explicação dos elementos:

| Elemento          | Propósito                                                                        |
| ----------------- | -------------------------------------------------------------------------------- |
| `version`         | Define a versão do formato do Compose.                                           |
| `services`        | Agrupamento de containers definidos na aplicação.                                |
| `db.image`        | Especifica a imagem oficial do PostgreSQL.                                       |
| `db.environment`  | Variáveis de ambiente usadas para inicializar o banco.                           |
| `db.volumes`      | Persistência dos dados do banco em volume nomeado.                               |
| `db.networks`     | Adiciona o container a uma rede chamada `springnet`.                             |
| `app.build`       | Indica que a imagem da aplicação será construída com base no `Dockerfile` local. |
| `app.ports`       | Mapeia a porta interna 8080 para a porta 8080 do host.                           |
| `app.environment` | Variáveis de ambiente passadas para o container Spring Boot.                     |
| `depends_on`      | Garante que o banco seja iniciado antes da aplicação.                            |
| `volumes`         | Define volumes nomeados usados por serviços.                                     |
| `networks`        | Define redes virtuais privadas para comunicação entre os containers.             |


### 🚀 3.3 Executando com Compose

```bash
docker-compose up --build -d
```

### 🔍 Explicação dos elementos:

| Componente           | Propósito                                                                                                                                                                                                  |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `docker-compose`     | Ferramenta que lê o arquivo `docker-compose.yml` e orquestra múltiplos containers. Permite definir imagens, volumes, redes e variáveis de ambiente de forma declarativa.                                   |
| `up`                 | Cria e inicia todos os serviços definidos no `docker-compose.yml`. Também cria as redes e volumes necessários.                                                                                             |
| `--build`            | Força a **construção ou reconstrução** das imagens definidas no serviço `build:` (como seu app Java Spring Boot), mesmo que uma imagem já exista localmente.                                               |
| `-d` (detached mode) | Roda os containers em segundo plano. Isso libera o terminal, permitindo que você continue usando o shell enquanto os serviços estão ativos. Você pode acompanhar os logs depois com `docker-compose logs`. |

### 🛑 Para parar os serviços:

```bash
docker-compose down
```

Isso remove os containers e a rede, mas mantém os volumes (a menos que você use `--volumes`).


### 📂 Teste

* GET: [http://localhost:8080/usuarios](http://localhost:8080/usuarios)
* POST com JSON:

```json
{ "nome": "Maria" }
```

#### `curl` - Unix

```bash
curl -X POST http://localhost:8080/usuarios -H "Content-Type: application/json" -d '{"nome":"Maria"}'
```
##### 🔍 Explicação dos elementos:

| Elemento                    | Significado                                                             |
| --------------------------- | ----------------------------------------------------------------------- |
| `curl`                      | Comando principal para realizar requisições HTTP pela linha de comando. |
| `-X POST`                   | Define o método HTTP (`POST`, nesse caso).                              |
| `http://localhost:8080/...` | URL do endpoint que está sendo acessado.                                |
| `-H "Content-Type: ..."`    | Define o cabeçalho HTTP (header), aqui dizendo que o corpo é JSON.      |
| `-d '{"nome":"Maria"}'`     | Define o corpo (body) da requisição, nesse caso, um JSON.               |

ℹ️ Obs: se você usar `-d`, o `curl` já assume `-X POST` automaticamente, mas é comum deixar explícito.

#### `Invoke-WebRequest` - Windows
```bash
Invoke-WebRequest -Uri "http://localhost:8080/usuarios" ` -Method POST ` -Headers @{ "Content-Type" = "application/json" } ` -Body '{ "nome": "Maria" }'
```

##### 🔍 Explicação dos elementos:
| Elemento                      | Significado                                                |
| ----------------------------- | ---------------------------------------------------------- |
| `Invoke-WebRequest`           | Comando do PowerShell para fazer requisições HTTP.         |
| `-Uri`                        | URL do endpoint que está sendo acessado.                   |
| `-Method POST`                | Define o método HTTP (`POST`, `GET`, `PUT`, etc.).         |
| `-Headers @{...}`             | Hashtable com os headers. Aqui, define que o corpo é JSON. |
| `-Body '{ "nome": "Maria" }'` | Corpo da requisição. No caso, um JSON.                     |


---

## ☁️ Parte 4: Publicando no Docker Hub (opcional)

### 4.1 Login

```bash
docker login
```

### 4.2 Tag

```bash
docker tag app-docker seuusuario/app-docker:latest
```

### 4.3 Push

```bash
docker push seuusuario/app-docker:latest
```

### 4.4 Executar a partir da imagem publicada

```bash
docker run -p 8080:8080 seuusuario/app-docker:latest
```

---

## 📚 Parte 5: Atividades

1. Modificar a entidade para incluir e-mail.
2. Adicionar endpoint para busca por nome.
3. Testar persistência reiniciando o banco.
4. Automatizar com GitHub Actions.

---

## ✅ Conclusão

* Entendimento de containers e seus benefícios.
* Uso de `Dockerfile` para compilar e executar aplicações.
* Orquestração com `docker-compose`.
* Integração de Spring Boot + PostgreSQL com persistência.
* Publicação de imagens no Docker Hub.

Próximos passos: utilizar Docker em ambientes de produção e automação com CI/CD.
