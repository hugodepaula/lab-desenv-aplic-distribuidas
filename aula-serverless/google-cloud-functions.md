# Tutorial Completo: Google Cloud Functions

## Introdução
Este tutorial mostrará como criar, desenvolver e implantar funções no Google Cloud Functions. Vamos criar uma API REST simples que responde a requisições HTTP.

## Pré-requisitos
- Conta Google Cloud Platform (GCP)
- Google Cloud SDK instalado
- Node.js instalado (versão 14 ou superior)
- Editor de código (VS Code recomendado)

## Parte 1: Configuração do Ambiente

### 1.1 Instalação do Google Cloud SDK
```bash
# Para Windows (usando PowerShell como administrador)
(New-Object Net.WebClient).DownloadFile("https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe", "$env:Temp\GoogleCloudSDKInstaller.exe")
& $env:Temp\GoogleCloudSDKInstaller.exe

# Para Mac (usando Homebrew)
brew install --cask google-cloud-sdk

# Para Linux
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
```

### 1.2 Inicialização e Autenticação
```bash
# Inicializar o SDK
gcloud init

# Autenticar com sua conta Google
gcloud auth login

# Configurar o projeto
gcloud config set project [SEU-ID-DO-PROJETO]
```

## Parte 2: Criando sua Primeira Function

### 2.1 Estrutura do Projeto
```bash
mkdir minha-primeira-function
cd minha-primeira-function
npm init -y
```

### 2.2 Código Básico (index.js)
```javascript
const functions = require('@google-cloud/functions-framework');

// Registrar uma função HTTP
functions.http('helloWorld', (req, res) => {
  const name = req.query.name || 'World';
  res.send(`Hello ${name}!`);
});
```

### 2.3 Package.json
```json
{
  "name": "minha-primeira-function",
  "version": "1.0.0",
  "description": "Minha primeira Google Cloud Function",
  "main": "index.js",
  "scripts": {
    "start": "functions-framework --target=helloWorld"
  },
  "dependencies": {
    "@google-cloud/functions-framework": "^3.0.0"
  }
}
```

## Parte 3: Exemplos Práticos

### 3.1 Function com Banco de Dados (Firestore)
```javascript
const functions = require('@google-cloud/functions-framework');
const { Firestore } = require('@google-cloud/firestore');

const firestore = new Firestore();

functions.http('saveUser', async (req, res) => {
  try {
    const { name, email } = req.body;
    
    // Validação básica
    if (!name || !email) {
      res.status(400).send('Name and email are required');
      return;
    }

    // Salvar no Firestore
    const docRef = firestore.collection('users').doc();
    await docRef.set({
      name,
      email,
      createdAt: new Date()
    });

    res.status(201).json({
      id: docRef.id,
      message: 'User created successfully'
    });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).send('Internal Server Error');
  }
});
```

### 3.2 Function com Pub/Sub
```javascript
const functions = require('@google-cloud/functions-framework');

functions.cloudEvent('processPubSub', (cloudEvent) => {
  const message = Buffer.from(cloudEvent.data.message.data, 'base64').toString();
  
  console.log(`Mensagem recebida: ${message}`);
  
  // Processar a mensagem
  const data = JSON.parse(message);
  // Fazer algo com os dados...
});
```

### 3.3 Function com Storage
```javascript
const functions = require('@google-cloud/functions-framework');
const { Storage } = require('@google-cloud/storage');

const storage = new Storage();

functions.cloudEvent('processFile', async (cloudEvent) => {
  const bucket = storage.bucket(cloudEvent.data.bucket);
  const file = bucket.file(cloudEvent.data.name);

  // Processar arquivo
  const [metadata] = await file.getMetadata();
  console.log(`Arquivo processado: ${metadata.name}`);
});
```

## Parte 4: Implantação

### 4.1 Implantação via linha de comando
```bash
# Implantação básica
gcloud functions deploy helloWorld \
  --runtime nodejs16 \
  --trigger-http \
  --allow-unauthenticated

# Implantação com variáveis de ambiente
gcloud functions deploy helloWorld \
  --runtime nodejs16 \
  --trigger-http \
  --set-env-vars FOO=bar,BAZ=qux \
  --allow-unauthenticated

# Implantação com memória específica e timeout
gcloud functions deploy helloWorld \
  --runtime nodejs16 \
  --trigger-http \
  --memory 512MB \
  --timeout 60s \
  --allow-unauthenticated
```

## Parte 5: Boas Práticas

### 5.1 Tratamento de Erros
```javascript
const functions = require('@google-cloud/functions-framework');

functions.http('robustFunction', async (req, res) => {
  try {
    // Validação de entrada
    if (!req.body || !req.body.data) {
      throw new Error('Invalid input');
    }

    // Processamento principal
    const result = await processData(req.body.data);

    // Resposta de sucesso
    res.status(200).json({
      success: true,
      data: result
    });

  } catch (error) {
    // Log do erro
    console.error('Error processing request:', error);

    // Resposta de erro estruturada
    res.status(error.code || 500).json({
      success: false,
      error: error.message || 'Internal Server Error',
      code: error.code || 500
    });
  }
});

async function processData(data) {
  // Implementação do processamento
}
```

### 5.2 Logging Estruturado
```javascript
const functions = require('@google-cloud/functions-framework');

functions.http('loggedFunction', (req, res) => {
  // Structured logging
  console.log(JSON.stringify({
    severity: 'INFO',
    message: 'Function invoked',
    httpRequest: {
      url: req.url,
      method: req.method,
      userAgent: req.get('user-agent'),
      referrer: req.get('referrer'),
    },
    timestamp: new Date().toISOString()
  }));

  res.send('Logged successfully');
});
```

## Parte 6: Testes

### 6.1 Testes Unitários (usando Jest)
```javascript
const {helloWorld} = require('./index');

describe('helloWorld', () => {
  it('should return Hello World', () => {
    const req = {
      query: {}
    };
    const res = {
      send: jest.fn()
    };

    helloWorld(req, res);
    expect(res.send).toHaveBeenCalledWith('Hello World!');
  });

  it('should return Hello [name]', () => {
    const req = {
      query: {
        name: 'John'
      }
    };
    const res = {
      send: jest.fn()
    };

    helloWorld(req, res);
    expect(res.send).toHaveBeenCalledWith('Hello John!');
  });
});
```

## Parte 7: Monitoramento

### 7.1 Configuração de Alertas
```javascript
const functions = require('@google-cloud/functions-framework');
const monitoring = require('@google-cloud/monitoring');

functions.http('monitoredFunction', async (req, res) => {
  const client = new monitoring.MetricServiceClient();
  const start = Date.now();

  try {
    // Seu código aqui
    res.send('Success');
  } finally {
    // Registrar métrica de duração
    const duration = Date.now() - start;
    await client.createTimeSeries({
      name: client.projectPath(process.env.GOOGLE_CLOUD_PROJECT),
      timeSeries: [{
        metric: {
          type: 'custom.googleapis.com/function/duration',
          labels: {
            function_name: process.env.FUNCTION_NAME,
          },
        },
        points: [{
          interval: {
            endTime: {
              seconds: Math.floor(Date.now() / 1000),
            },
          },
          value: {
            doubleValue: duration,
          },
        }],
      }],
    });
  }
});
```

## Dicas e Truques

1. **Cold Starts**: Minimize o impacto usando:
   - Declarações globais para conexões reutilizáveis
   - Lazy loading quando possível
   - Funções mais leves

2. **Segurança**:
   - Use IAM para controle de acesso
   - Valide todas as entradas
   - Use HTTPS
   - Implemente rate limiting

3. **Performance**:
   - Use caching quando apropriado
   - Otimize dependências
   - Monitore uso de memória

## Solução de Problemas Comuns

1. **Erro de Timeout**:
   - Aumente o timeout na configuração
   - Otimize o código
   - Use processamento assíncrono

2. **Problemas de Memória**:
   - Aumente a memória alocada
   - Verifique memory leaks
   - Otimize uso de recursos

3. **Erros de Conexão**:
   - Verifique configurações de rede
   - Implemente retry logic
   - Use connection pooling

## Recursos Adicionais
- [Documentação Oficial](https://cloud.google.com/functions/docs)
- [Exemplos de Código](https://github.com/GoogleCloudPlatform/nodejs-docs-samples/tree/main/functions)
- [Melhores Práticas](https://cloud.google.com/functions/docs/bestpractices/tips)
