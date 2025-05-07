# Tutorial: Criando sua Primeira Skill da Alexa

## Introdução
Neste tutorial, vamos criar uma skill simples que responde com fatos curiosos sobre tecnologia. A skill responderá quando o usuário disser "Alexa, abrir fatos de tecnologia" e poderá fornecer um fato aleatório quando solicitado.

## Passo 1: Criar uma Conta de Desenvolvedor
1. Acesse https://developer.amazon.com
2. Clique em "Sign In" no canto superior direito
3. Selecione "Create a New Account" se ainda não tiver uma
4. Preencha suas informações e confirme seu e-mail

## Passo 2: Acessar o Alexa Developer Console
1. Após fazer login, vá para https://developer.amazon.com/alexa/console/ask
2. Clique no botão "Create Skill"
3. Digite "Fatos de Tecnologia" como nome da skill
4. Selecione "Portuguese (BR)" como idioma principal
5. Escolha "Custom" como modelo
6. Selecione "Alexa-Hosted (Node.js)" como método de hospedagem
7. Clique em "Create skill"

## Passo 3: Configurar o Modelo de Interação
1. Na barra lateral esquerda, clique em "Invocation"
2. Digite "fatos de tecnologia" como nome de invocação
3. Clique em "Save Model"

### Criar Intents
1. Na barra lateral, clique em "Intents"
2. Clique em "Add Intent"
3. Crie os seguintes intents:

#### GetNewFactIntent
1. Nome do intent: "GetNewFactIntent"
2. Adicione as seguintes sample utterances:
   ```
   me conte um fato
   diga um fato
   fato aleatório
   quero saber um fato
   me ensine algo novo
   ```
3. Clique em "Save Model"

## Passo 4: Desenvolver a Lógica da Skill
1. Clique em "Code" no menu superior
2. Substitua o conteúdo do arquivo index.js pelo seguinte código:

```javascript
const Alexa = require('ask-sdk-core');

const fatos = [
    'O primeiro computador pessoal com interface gráfica foi o Xerox Alto, criado em 1973.',
    'O primeiro e-mail foi enviado em 1971 pelo engenheiro Ray Tomlinson.',
    'O símbolo @ foi escolhido para e-mails por ser raro em nomes e pouco usado na época.',
    'O primeiro smartphone foi o IBM Simon, lançado em 1994.',
    'O primeiro website do mundo ainda está no ar e foi criado em 1991.'
];

const LaunchRequestHandler = {
    canHandle(handlerInput) {
        return Alexa.getRequestType(handlerInput.requestEnvelope) === 'LaunchRequest';
    },
    handle(handlerInput) {
        const speakOutput = 'Bem-vindo aos Fatos de Tecnologia! Você quer ouvir um fato interessante?';
        return handlerInput.responseBuilder
            .speak(speakOutput)
            .reprompt(speakOutput)
            .getResponse();
    }
};

const GetNewFactIntentHandler = {
    canHandle(handlerInput) {
        return Alexa.getRequestType(handlerInput.requestEnvelope) === 'IntentRequest'
            && Alexa.getIntentName(handlerInput.requestEnvelope) === 'GetNewFactIntent';
    },
    handle(handlerInput) {
        const fatoAleatorio = fatos[Math.floor(Math.random() * fatos.length)];
        const speakOutput = fatoAleatorio;
        
        return handlerInput.responseBuilder
            .speak(speakOutput + ' Quer ouvir outro fato?')
            .reprompt('Quer ouvir outro fato interessante?')
            .getResponse();
    }
};

const HelpIntentHandler = {
    canHandle(handlerInput) {
        return Alexa.getRequestType(handlerInput.requestEnvelope) === 'IntentRequest'
            && Alexa.getIntentName(handlerInput.requestEnvelope) === 'AMAZON.HelpIntent';
    },
    handle(handlerInput) {
        const speakOutput = 'Você pode dizer "me conte um fato" para ouvir um fato interessante sobre tecnologia.';

        return handlerInput.responseBuilder
            .speak(speakOutput)
            .reprompt(speakOutput)
            .getResponse();
    }
};

const CancelAndStopIntentHandler = {
    canHandle(handlerInput) {
        return Alexa.getRequestType(handlerInput.requestEnvelope) === 'IntentRequest'
            && (Alexa.getIntentName(handlerInput.requestEnvelope) === 'AMAZON.CancelIntent'
                || Alexa.getIntentName(handlerInput.requestEnvelope) === 'AMAZON.StopIntent');
    },
    handle(handlerInput) {
        const speakOutput = 'Até logo!';
        return handlerInput.responseBuilder
            .speak(speakOutput)
            .getResponse();
    }
};

exports.handler = Alexa.SkillBuilders.custom()
    .addRequestHandlers(
        LaunchRequestHandler,
        GetNewFactIntentHandler,
        HelpIntentHandler,
        CancelAndStopIntentHandler
    )
    .lambda();
```

3. Clique em "Save" e depois em "Deploy"

## Passo 5: Testar a Skill
1. Clique em "Test" no menu superior
2. Habilite o teste alterando o dropdown para "Development"
3. Você pode testar de duas formas:
   - Usando o microfone: clique no ícone de microfone e fale
   - Digitando: digite comandos como "abrir fatos de tecnologia"

### Exemplos de teste:
1. Digite ou diga: "abrir fatos de tecnologia"
   - A Alexa deve responder com uma mensagem de boas-vindas
2. Digite ou diga: "me conte um fato"
   - A Alexa deve responder com um fato aleatório
3. Digite ou diga: "ajuda"
   - A Alexa deve explicar como usar a skill

## Passo 6: Distribuição (Opcional)
1. Clique em "Distribution" no menu superior
2. Preencha as informações necessárias:
   - Descrição curta e longa da skill
   - Palavras-chave
   - Exemplo de frases
   - Ícone da skill (pode usar um placeholder inicialmente)
3. Complete todas as seções obrigatórias
4. Submeta para certificação

## Dicas para Desenvolvimento
- Sempre teste todas as utterances possíveis
- Mantenha as respostas curtas e naturais
- Adicione variações nas respostas para tornar a interação mais natural
- Teste a skill em diferentes dispositivos se possível
- Mantenha os fatos atualizados e precisos

## Solução de Problemas Comuns
1. Se a skill não responde:
   - Verifique se o código foi salvo e deployado
   - Confirme se o modelo de interação foi salvo e construído
   - Verifique os logs na aba "Code"

2. Se as utterances não são reconhecidas:
   - Verifique se foram salvas corretamente
   - Reconstrua o modelo de interação
   - Teste diferentes variações das frases

3. Se o teste não funciona:
   - Confirme se o ambiente de teste está em "Development"
   - Verifique se não há erros no console
   - Tente limpar o cache do navegador

## Próximos Passos
Após completar este tutorial básico, você pode:
1. Adicionar mais fatos à lista
2. Criar categorias de fatos
3. Adicionar sons e efeitos usando SSML
4. Implementar persistência para não repetir fatos
5. Adicionar uma interface visual usando APL

## Recursos Adicionais
- Documentação oficial: https://developer.amazon.com/docs/alexa-skills-kit-sdk-for-nodejs/overview.html
- Fórum de desenvolvedores: https://forums.developer.amazon.com/
- Exemplos de código: https://github.com/alexa/alexa-skills-kit-sdk-for-nodejs
