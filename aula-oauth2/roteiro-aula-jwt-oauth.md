# Roteiro de Aula Prática: Autenticação JWT e OAuth com Python

## Objetivos
- Compreender os conceitos de autenticação JWT (JSON Web Token)
- Implementar autenticação JWT em uma API Flask
- Entender o fluxo de autorização OAuth 2.0
- Integrar autenticação OAuth de terceiros em uma aplicação web Python

## Pré-requisitos
- Python 3.8 ou superior instalado
- Editor de código (VS Code, PyCharm, etc.)
- Conhecimento básico de APIs REST e HTTP
- Conhecimento básico de Flask

## Material Necessário
- Computador com acesso à internet
- Postman ou outra ferramenta para testar APIs (opcional)

## Parte 1: Autenticação JWT com Flask

### Passo 1: Configuração do Ambiente

1. Crie uma pasta para o projeto:
```bash
mkdir projeto_autenticacao
cd projeto_autenticacao
```

2. Crie um ambiente virtual e ative-o:
```bash
python -m venv venv
# Windows
venv\Scripts\activate
# Linux/Mac
source venv/bin/activate
```

3. Instale as dependências necessárias:
```bash
pip install flask flask-jwt-extended python-dotenv
```

4. Crie a estrutura básica do projeto:
```bash
touch .env app.py
mkdir templates static
```

5. Configure o arquivo .env:
```
SECRET_KEY=seu_segredo_super_secreto
```

### Passo 2: Implementando a API com JWT

1. Abra o arquivo `app.py` e adicione o código inicial:

```python
from flask import Flask, request, jsonify, render_template
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
from datetime import timedelta
import os
from dotenv import load_dotenv

# Carrega as variáveis de ambiente
load_dotenv()

app = Flask(__name__)
app.config['JWT_SECRET_KEY'] = os.getenv('SECRET_KEY')
app.config['JWT_ACCESS_TOKEN_EXPIRES'] = timedelta(hours=1)
jwt = JWTManager(app)

# Simulação de banco de dados de usuários
users_db = {
    'aluno@exemplo.com': {
        'password': 'senha123',
        'name': 'Aluno Exemplo'
    }
}

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/api/login', methods=['POST'])
def login():
    if not request.is_json:
        return jsonify({"msg": "Requisição precisa ter formato JSON"}), 400
    
    email = request.json.get('email', None)
    password = request.json.get('password', None)
    
    if not email or not password:
        return jsonify({"msg": "Campos email e password são obrigatórios"}), 400
    
    user = users_db.get(email, None)
    if not user or user['password'] != password:
        return jsonify({"msg": "Credenciais inválidas"}), 401
    
    # Cria o token JWT
    access_token = create_access_token(identity=email)
    return jsonify(access_token=access_token, name=user['name']), 200

@app.route('/api/protected', methods=['GET'])
@jwt_required()
def protected():
    current_user = get_jwt_identity()
    user_info = users_db.get(current_user)
    
    return jsonify(
        logged_in_as=current_user,
        name=user_info['name'],
        msg="Você acessou um endpoint protegido!"
    ), 200

if __name__ == '__main__':
    app.run(debug=True)
```

2. Crie um arquivo HTML básico para interface. Na pasta `templates`, crie o arquivo `index.html`:

```html
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Autenticação JWT</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .container {
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .result {
            background-color: #f5f5f5;
            padding: 10px;
            border-radius: 5px;
            margin-top: 10px;
            white-space: pre-wrap;
        }
        button {
            padding: 8px 15px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        input {
            padding: 8px;
            margin: 5px 0;
            width: 100%;
        }
    </style>
</head>
<body>
    <h1>Demonstração de Autenticação JWT</h1>
    
    <div class="container">
        <h2>Login</h2>
        <div>
            <label for="email">Email:</label>
            <input type="email" id="email" value="aluno@exemplo.com">
        </div>
        <div>
            <label for="password">Senha:</label>
            <input type="password" id="password" value="senha123">
        </div>
        <button onclick="login()">Login</button>
        <div class="result" id="loginResult"></div>
    </div>
    
    <div class="container">
        <h2>Acesso Protegido</h2>
        <button onclick="accessProtected()">Acessar recurso protegido</button>
        <div class="result" id="protectedResult"></div>
    </div>
    
    <script>
        let token = '';
        
        async function login() {
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            
            try {
                const response = await fetch('/api/login', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ email, password }),
                });
                
                const data = await response.json();
                
                if (response.ok) {
                    token = data.access_token;
                    document.getElementById('loginResult').textContent = `Login bem-sucedido! Nome: ${data.name}\nToken: ${token}`;
                } else {
                    document.getElementById('loginResult').textContent = `Erro: ${data.msg}`;
                }
            } catch (error) {
                document.getElementById('loginResult').textContent = `Erro: ${error.message}`;
            }
        }
        
        async function accessProtected() {
            try {
                const response = await fetch('/api/protected', {
                    method: 'GET',
                    headers: {
                        'Authorization': `Bearer ${token}`
                    }
                });
                
                const data = await response.json();
                
                if (response.ok) {
                    document.getElementById('protectedResult').textContent = JSON.stringify(data, null, 2);
                } else {
                    document.getElementById('protectedResult').textContent = `Erro: ${data.msg}`;
                }
            } catch (error) {
                document.getElementById('protectedResult').textContent = `Erro: ${error.message}`;
            }
        }
    </script>
</body>
</html>
```

### Passo 3: Testar a Autenticação JWT

1. Execute o servidor Flask:
```bash
python app.py
```

2. Acesse http://localhost:5000 no navegador

3. Use as credenciais fornecidas para fazer login:
   - Email: aluno@exemplo.com
   - Senha: senha123

4. Observe o token JWT gerado

5. Clique em "Acessar recurso protegido" para verificar a autenticação

6. Experimente:
   - Modificar o token manualmente e tentar acessar novamente
   - Deixar o token expirar (aguarde 1 hora ou modifique o tempo de expiração para testar)

## Parte 2: Autenticação OAuth com Google

### Passo 1: Configuração do OAuth no Google Cloud

1. Acesse o [Google Cloud Console](https://console.cloud.google.com/)
2. Crie um novo projeto ou selecione um existente
3. Vá para "APIs e Serviços" > "Credenciais"
4. Clique em "Criar Credenciais" > "ID do Cliente OAuth"
5. Configure a tela de consentimento do OAuth:
   - Tipo de usuário: Externo
   - Nome do aplicativo: Aula Prática Python
   - Email de suporte: seu-email@exemplo.com
   - Domínios autorizados: localhost
   - Escopos: userinfo.email, userinfo.profile
6. Crie o ID do cliente OAuth:
   - Tipo de aplicativo: Aplicativo da Web
   - Nome: Aula Prática Python
   - Origens JavaScript autorizadas: http://localhost:5000
   - URIs de redirecionamento autorizados: http://localhost:5000/callback
7. Anote o ID do Cliente e o Segredo do Cliente

### Passo 2: Implementação do OAuth no Python

1. Instale as dependências adicionais:
```bash
pip install requests
```

2. Adicione as novas variáveis ao arquivo .env:
```
GOOGLE_CLIENT_ID=seu_client_id_do_google
GOOGLE_CLIENT_SECRET=seu_client_secret_do_google
```

3. Modifique o arquivo `app.py` para incluir OAuth:

```python
from flask import Flask, request, jsonify, render_template, redirect, url_for, session
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
from datetime import timedelta
import os
import secrets
import requests
from dotenv import load_dotenv

# Carrega as variáveis de ambiente
load_dotenv()

app = Flask(__name__)
app.secret_key = os.getenv('SECRET_KEY')
app.config['JWT_SECRET_KEY'] = os.getenv('SECRET_KEY')
app.config['JWT_ACCESS_TOKEN_EXPIRES'] = timedelta(hours=1)
jwt = JWTManager(app)

# Configurações OAuth Google
GOOGLE_CLIENT_ID = os.getenv('GOOGLE_CLIENT_ID')
GOOGLE_CLIENT_SECRET = os.getenv('GOOGLE_CLIENT_SECRET')
GOOGLE_DISCOVERY_URL = "https://accounts.google.com/.well-known/openid-configuration"

# Simulação de banco de dados de usuários
users_db = {
    'aluno@exemplo.com': {
        'password': 'senha123',
        'name': 'Aluno Exemplo'
    }
}

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/api/login', methods=['POST'])
def login():
    if not request.is_json:
        return jsonify({"msg": "Requisição precisa ter formato JSON"}), 400
    
    email = request.json.get('email', None)
    password = request.json.get('password', None)
    
    if not email or not password:
        return jsonify({"msg": "Campos email e password são obrigatórios"}), 400
    
    user = users_db.get(email, None)
    if not user or user['password'] != password:
        return jsonify({"msg": "Credenciais inválidas"}), 401
    
    # Cria o token JWT
    access_token = create_access_token(identity=email)
    return jsonify(access_token=access_token, name=user['name']), 200

@app.route('/api/protected', methods=['GET'])
@jwt_required()
def protected():
    current_user = get_jwt_identity()
    user_info = users_db.get(current_user)
    
    return jsonify(
        logged_in_as=current_user,
        name=user_info['name'],
        msg="Você acessou um endpoint protegido!"
    ), 200

# Rotas OAuth

@app.route('/login/google')
def login_google():
    # Gera um estado aleatório para proteção contra CSRF
    session['oauth_state'] = secrets.token_urlsafe(16)
    
    # Determina quais informações do usuário serão solicitadas
    scope = "openid email profile"
    
    # Constrói a URL de autorização
    auth_url = f"https://accounts.google.com/o/oauth2/v2/auth?response_type=code&client_id={GOOGLE_CLIENT_ID}&redirect_uri={url_for('callback', _external=True)}&scope={scope}&state={session['oauth_state']}"
    
    return redirect(auth_url)

@app.route('/callback')
def callback():
    # Verifica o estado para proteção contra CSRF
    if request.args.get('state') != session.get('oauth_state'):
        return jsonify({"error": "Estado inválido"}), 400
    
    # Obtém o código de autorização
    code = request.args.get('code')
    if not code:
        return jsonify({"error": "Código não fornecido"}), 400
    
    # Troca o código por um token de acesso
    token_url = "https://oauth2.googleapis.com/token"
    token_data = {
        'client_id': GOOGLE_CLIENT_ID,
        'client_secret': GOOGLE_CLIENT_SECRET,
        'code': code,
        'grant_type': 'authorization_code',
        'redirect_uri': url_for('callback', _external=True)
    }
    
    token_response = requests.post(token_url, data=token_data)
    token_json = token_response.json()
    
    if 'error' in token_json:
        return jsonify({"error": token_json['error']}), 400
    
    # Obtém informações do usuário usando o token de acesso
    userinfo_url = "https://www.googleapis.com/oauth2/v3/userinfo"
    userinfo_response = requests.get(
        userinfo_url,
        headers={'Authorization': f"Bearer {token_json['access_token']}"}
    )
    userinfo = userinfo_response.json()
    
    # Verifica se o email está presente e verificado
    if not userinfo.get('email_verified'):
        return jsonify({"error": "Email não verificado"}), 400
    
    # Adiciona o usuário ao banco de dados se não existir
    email = userinfo['email']
    if email not in users_db:
        users_db[email] = {
            'name': userinfo.get('name', 'Usuário Google'),
            'password': None  # Usuário OAuth não tem senha local
        }
    
    # Cria o token JWT
    access_token = create_access_token(identity=email)
    
    # Renderiza uma página de sucesso com o token
    return render_template('oauth_success.html', 
                           access_token=access_token, 
                           user_name=userinfo.get('name'),
                           user_email=email)

if __name__ == '__main__':
    app.run(debug=True)
```

4. Crie o modelo de página de sucesso de OAuth. Na pasta `templates`, crie o arquivo `oauth_success.html`:

```html
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login OAuth Bem-sucedido</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .container {
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .result {
            background-color: #f5f5f5;
            padding: 10px;
            border-radius: 5px;
            margin-top: 10px;
            white-space: pre-wrap;
        }
        button {
            padding: 8px 15px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <h1>Login OAuth Bem-sucedido!</h1>
    
    <div class="container">
        <h2>Informações do Usuário</h2>
        <p><strong>Nome:</strong> {{ user_name }}</p>
        <p><strong>Email:</strong> {{ user_email }}</p>
        
        <h3>Token JWT</h3>
        <div class="result">{{ access_token }}</div>
        
        <h3>O que fazer agora?</h3>
        <p>Você pode usar este token para acessar rotas protegidas, como fizemos na demonstração de JWT.</p>
        
        <a href="/" style="display: inline-block; margin-top: 20px; text-decoration: none;">
            <button>Voltar para a página inicial</button>
        </a>
    </div>
</body>
</html>
```

5. Atualize o arquivo `index.html` para incluir um botão de login com Google:

```html
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <!-- [Manter o código existente] -->
</head>
<body>
    <h1>Demonstração de Autenticação JWT e OAuth</h1>
    
    <div class="container">
        <h2>Login Local (JWT)</h2>
        <div>
            <label for="email">Email:</label>
            <input type="email" id="email" value="aluno@exemplo.com">
        </div>
        <div>
            <label for="password">Senha:</label>
            <input type="password" id="password" value="senha123">
        </div>
        <button onclick="login()">Login</button>
        <div class="result" id="loginResult"></div>
    </div>
    
    <div class="container">
        <h2>Login com Google (OAuth)</h2>
        <p>Clique no botão abaixo para fazer login com sua conta Google:</p>
        <a href="/login/google">
            <button>Login com Google</button>
        </a>
    </div>
    
    <div class="container">
        <h2>Acesso Protegido</h2>
        <button onclick="accessProtected()">Acessar recurso protegido</button>
        <div class="result" id="protectedResult"></div>
    </div>
    
    <script>
        // [Manter o código JavaScript existente]
    </script>
</body>
</html>
```

### Passo 3: Testar a Autenticação OAuth

1. Execute o servidor Flask:
```bash
python app.py
```

2. Acesse http://localhost:5000 no navegador

3. Clique em "Login com Google"

4. Siga o fluxo de autorização do Google

5. Observe que você é redirecionado de volta para o aplicativo com um token JWT

6. Use esse token para acessar o recurso protegido

## Parte 3: Atividades Práticas para os Alunos

### Atividade 1: Implementar Refresh Tokens
1. Modifique o sistema JWT para usar refresh tokens
2. Adicione um endpoint `/api/refresh` que aceita refresh tokens e emite novos access tokens
3. Atualize a interface para lidar com tokens expirados automaticamente

### Atividade 2: Adicionar Outro Provedor OAuth
1. Implemente autenticação OAuth com outro provedor (GitHub, Facebook, etc.)
2. Crie um botão de login para o novo provedor na interface
3. Implemente o fluxo de autorização e obtenção de tokens

### Atividade 3: Melhorar a Segurança
1. Adicione validação de password usando bcrypt ou outra biblioteca de hash
2. Implemente verificação de força da senha
3. Adicione limites de tentativas de login para prevenir ataques de força bruta

## Recursos Adicionais
- [Documentação oficial do Flask-JWT-Extended](https://flask-jwt-extended.readthedocs.io/)
- [OAuth 2.0 - Guia do Desenvolvedor](https://oauth.net/2/)
- [Documentação OAuth do Google](https://developers.google.com/identity/protocols/oauth2)
- [JWT.io - Debugger de JWT](https://jwt.io/)

## Conclusão
Nesta aula prática, você aprendeu:
- Como implementar autenticação JWT em uma API Flask
- Como funciona o fluxo de autorização OAuth 2.0
- Como integrar login social usando Google OAuth
- Boas práticas de segurança para autenticação em aplicações web

A combinação de JWT e OAuth oferece um sistema de autenticação robusto, seguro e com boa experiência do usuário para suas aplicações web.