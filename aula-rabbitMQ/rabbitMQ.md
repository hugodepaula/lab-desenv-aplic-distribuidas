# Roteiro de Trabalho: Arquitetura Orientada a Mensagens com RabbitMQ

Este roteiro apresenta os conceitos básicos de *Message Oriented Architectures* (MOA) usando o RabbitMQ.

## Filas de Mensagens, Producers e Consumers

Filas de mensagens funcionam como buffers, armazenando mensagens enviadas por produtores até que sejam processadas por consumidores. Este modelo de comunicação permite desacoplamento espacial e temporal entre componentes.

- Desacoplamento: producer e consumer não precisam estar disponíveis simultaneamente.
- Escalabilidade: é possível adicionar mais consumers para processar mensagens em paralelo.
- Resiliência: as mensagens permanecem na fila mesmo se o consumer falhar.
- Balanceamento de carga: múltiplos consumers podem compartilhar o trabalho.

### Filas de Mensagens

Uma fila é essencialmente um buffer que armazena mensagens em uma ordem sequencial (*FIFO - First In, First Out*), mantendo-as até que um consumidor esteja disponível para processá-las.

![Componentes de uma fila de mensagens](./fila.png)

Fonte: <https://www.rabbitmq.com/tutorials#queue-tutorials>

O *Message Broker* (como o RabbitMQ) é responsável por gerenciar essas filas, garantindo que as mensagens sejam entregues de forma confiável e eficiente.

> **OBSERVAÇÂO**: O protocolo AMQP só garante ordenação de mensagens em um canal com um exchange e uma fila de mensagens. O RabbitMQ garante ordenação de mensagens em uma fila, mas não garante ordenação entre filas.

### Producer/Publisher

O *Producer* (ou *Publisher*) é responsável por enviar mensagens para o message broker:

- Encapsula esses dados em mensagens e os envia para o broker.
- Pode selecionar diferentes exchanges e chaves de roteamento dependendo do destino da mensagem.

### Consumer/Subscriber

O Consumer recebe e processa as mensagens da fila:

- Conecta-se a uma fila específica
- Recupera e processa as mensagens conforme elas chegam.
- Retorna *acknowledgement* para garantia de entregas.

## O Modelo Arquitetural Publish/Subscribe

O modelo Publish/Subscribe (pub/sub) permite a entrega de uma mensagem para múltiplos consumidores interessados. Diferentemente do modelo de fila simples, onde cada mensagem vai para apenas um consumidor, no modelo pub/sub, uma mensagem pode ser recebida por vários consumers.

![Funcionamento de exchanges no RabbitMQ](./exchange.png)

Fonte: <https://www.rabbitmq.com/tutorials#queue-tutorials>

### Exchanges

No RabbitMQ, os publishers não enviam mensagens diretamente para as filas. Em vez disso, eles enviam para um intermediário chamado Exchange (como uma caixa postal). O Exchange é responsável por rotear as mensagens para filas específicas com base em:

- Tipo do exchange
- Regras de binding (vínculos entre exchanges e filas)
- Chaves de roteamento (routing keys)

### Tipos de Exchanges

O RabbitMQ oferece quatro tipos principais de exchanges, cada um com um comportamento de roteamento específico:

1. **Direct**: As mensagens são roteadas para filas onde a chave de binding coincide exatamente com a routing key da mensagem.
2. **Fanout**: Distribui todas as mensagens para todas as filas vinculadas a ele, ignorando as *routing keys*. Ideal para broadcast de mensagens.
3. **Topic**: Realiza o roteamento com base em padrões (*wildcards*) entre a chave de roteamento da mensagem e a *binding key* das filas.
4. **Headers**: Roteia mensagens com base nos cabeçalhos definidos nas mensagens, não utilizando a *routing key*.

### Bindings

São regras que determinam como as mensagens são roteadas dos exchanges para as filas. Um *binding* é um link entre um exchange e uma fila, associado a *routing key*.

## O Problema do Roteamento de Mensagens Usando Estrutura de Tópicos

O roteamento de mensagens é um desafio em sistemas distribuídos, especialmente quando há necessidade de direcionar mensagens específicas para diferentes consumidores baseados em critérios particulares.

### Estrutura de Tópicos

No RabbitMQ, o exchange do tipo *Topic* encaminha mensagens baseados na *routing key*, uma string composta por palavras separadas por pontos (por exemplo, "bolsa.acoes.petr4").

![Funcionamento de exchanges no RabbitMQ](./topic.png)

Fonte: <https://www.rabbitmq.com/tutorials#queue-tutorials>

### Wildcards no Roteamento por Tópicos

O exchange Topic suporta dois tipos de wildcards:

- `*` (asterisco): substitui exatamente uma palavra.
- `#` (hashtag): substitui zero ou mais palavras.

Por exemplo:

- Uma fila com *binding key* "bolsa.acoes.*" receberia mensagens com routing keys como "bolsa.acoes.petr4" ou "bolsa.acoes.itub4"
- Uma fila com *binding key* "bolsa.\#" receberia todas as mensagens relacionadas à bolsa

---

### Aplicação no Contexto da Bolsa de Valores

Neste tutorial iremos desenvolver um sistema para uma bolsa de valores qualquer, como a Bovespa, utilizando o RabbitMQ. Quem quiser conhecer um pouco mais sobre o funcionamento da bolsa de valores, visite o site da BOVESPA em <http://www.b3.com.br/pt_br/market-data-e-indices/servicos-de-dados/market-data/cotacoes/>.
A corretora (ou broker) pode enviar as seguintes operações à bolsa de valores:

- "bolsa.cotacoes.acoes.petr4" - para cotações específicas da Petrobras
- "bolsa.negociacoes.\#" - para todas as mensagens relacionadas a negociações
- "bolsa.*.dividendos" - para informações sobre dividendos de qualquer segmento

## Deploy de um Servidor RabbitMQ Utilizando CloudAMQP

O CloudAMQP oferece serviços gerenciados de RabbitMQ na nuvem, incluindo um plano gratuito (Little Lemur) ideal para testes e projetos pequenos.

### Passo 1: Criação de Conta e Instância

1. Acesse <https://www.cloudamqp.com/> e clique em "Sign Up"
2. Após criar sua conta, clique em "Create New Instance"
3. Selecione o plano "Little Lemur" (gratuito)
4. Escolha um nome para sua instância (exemplo: "bolsa-mensagens")
5. Selecione um provedor de nuvem (AWS, GCP, Azure, etc.)
6. Selecione uma região próxima da sua localização
7. Clique em "Create instance"

### Passo 2: Configuração da Instância

1. Na dashboard do CloudAMQP, clique na instância criada
2. Anote as informações de conexão (AMQP URL)
3. Acesse o painel RabbitMQ Management clicando em "RabbitMQ Manager"

### Passo 3: Criação de Exchanges e Filas

1. No painel RabbitMQ Management, vá para a aba "Exchanges"
2. Clique em "Add a new exchange"
3. Configure um exchange tipo Topic chamado "bolsa":
    - Name: `bolsa`
    - Type: topic
    - Durability: Durable
    - Auto delete: No
4. Vá para a aba "Queues"
5. Crie uma fila para cotações:
    - Name: `cotacoes`
    - Durability: Durable
6. Crie uma fila para negociações:
    - Name: `negociacoes`
    - Durability: Durable

### Passo 4: Configuração de Bindings

1. Acesse a fila "cotacoes"
2. Na seção "Bindings", adicione um binding:
    - From exchange: `bolsa`
    - Routing key: `bolsa.cotacoes.\#`
3. Acesse a fila "negociacoes"
4. Na seção "Bindings", adicione um binding:
    - From exchange: `bolsa`
    - Routing key: `bolsa.negociacoes.\#`

## Implementação Prática: Criação do Producer (Servidor)

Vamos implementar um producer em Python que enviará mensagens relacionadas à bolsa de valores.

### Passo 1: Configuração do Ambiente

```python
# Instale a biblioteca pika
# pip install pika

import pika
import json
import time
import random
```

### Passo 2: Configuração da Conexão

```python
def conectar_rabbitmq(amqp_url):
    """Estabelece conexão com o RabbitMQ."""
    params = pika.URLParameters(amqp_url)
    params.socket_timeout = 5
    connection = pika.BlockingConnection(params)
    channel = connection.channel()
    
    # Declarar exchange
    channel.exchange_declare(
        exchange='bolsa',
        exchange_type='topic',
        durable=True
    )
    
    return connection, channel
```

### Passo 3: Função para Publicar Mensagens

```python
def publicar_mensagem(channel, routing_key, mensagem):
    """Publica uma mensagem no exchange com a routing key especificada."""
    channel.basic_publish(
        exchange='bolsa',
        routing_key=routing_key,
        body=json.dumps(mensagem),
        properties=pika.BasicProperties(
            delivery_mode=2,  # Mensagem persistente
            content_type='application/json'
        )
    )
    print(f"Mensagem enviada: {routing_key} - {mensagem}")
```

### Passo 4: Simulação de Producer da Bolsa

```python
def simular_bolsa():
    """Simula um producer enviando dados da bolsa de valores."""
    # URL de conexão do CloudAMQP - substitua pela sua URL
    amqp_url = 'amqp://usuario:senha@servidor.cloudamqp.com/vhost'
    
    # Conectar ao RabbitMQ
    connection, channel = conectar_rabbitmq(amqp_url)
    
    acoes = ['PETR4', 'VALE3', 'ITUB4', 'BBDC4', 'ABEV3']
    
    try:
        # Simulação de envio contínuo de mensagens
        for i in range(20):
            # Simular cotação aleatória
            acao = random.choice(acoes)
            valor = round(random.uniform(10, 100), 2)
            variacao = round(random.uniform(-5, 5), 2)
            
            # Mensagem de cotação
            mensagem_cotacao = {
                'acao': acao,
                'valor': valor,
                'variacao': variacao,
                'timestamp': time.time()
            }
            
            # Routing key para cotação
            routing_key = f'bolsa.cotacoes.acoes.{acao.lower()}'
            publicar_mensagem(channel, routing_key, mensagem_cotacao)
            
            # Ocasionalmente simular uma negociação
            if random.random() > 0.7:
                quantidade = random.randint(100, 10000)
                tipo = random.choice(['compra', 'venda'])
                
                mensagem_negociacao = {
                    'acao': acao,
                    'quantidade': quantidade,
                    'valor_total': quantidade * valor,
                    'tipo': tipo,
                    'timestamp': time.time()
                }
                
                # Routing key para negociação
                routing_key = f'bolsa.negociacoes.{tipo}.{acao.lower()}'
                publicar_mensagem(channel, routing_key, mensagem_negociacao)
            
            time.sleep(1)  # Intervalo entre mensagens
    
    finally:
        connection.close()
        print("Conexão fechada")

if __name__ == "__main__":
    simular_bolsa()
```

## Implementação Prática: Criação do Consumer (Cliente)

Agora vamos implementar um consumer em Python que processará as mensagens da bolsa de valores.

### Passo 1: Configuração do Ambiente do Consumer

```python
# Instale a biblioteca pika
# pip install pika==1.1.0

import pika
import json
import time
```

### Passo 2: Configuração da Conexão do Consumer

```python
def conectar_rabbitmq(amqp_url, queue_name, binding_key):
    """Estabelece conexão com o RabbitMQ e configura a fila."""
    params = pika.URLParameters(amqp_url)
    connection = pika.BlockingConnection(params)
    channel = connection.channel()
    
    # Declarar exchange
    channel.exchange_declare(
        exchange='bolsa',
        exchange_type='topic',
        durable=True
    )
    
    # Declarar fila
    channel.queue_declare(
        queue=queue_name,
        durable=True
    )
    
    # Vincular a fila ao exchange
    channel.queue_bind(
        exchange='bolsa',
        queue=queue_name,
        routing_key=binding_key
    )
    
    return connection, channel
```

### Passo 3: Função de Callback para Processar Mensagens

```python
def processar_mensagem(ch, method, properties, body):
    """Callback para processar mensagens recebidas."""
    try:
        # Converter a mensagem JSON para dicionário
        mensagem = json.loads(body)
        
        # Extrair a routing key
        routing_key = method.routing_key
        
        print(f"\nRecebida mensagem com routing key: {routing_key}")
        print(f"Conteúdo: {mensagem}")
        
        # Simulação de processamento
        print("Processando mensagem...")
        time.sleep(0.5)  # Simular processamento
        
        # Verificar tipo de mensagem pelo routing key
        if 'cotacoes' in routing_key:
            # Processar cotação
            acao = mensagem['acao']
            valor = mensagem['valor']
            variacao = mensagem['variacao']
            print(f"Cotação de {acao}: R$ {valor} (variação: {variacao}%)")
            
            # Simular análise técnica
            if variacao > 2:
                print(f"ALERTA: {acao} em alta expressiva!")
            elif variacao < -2:
                print(f"ALERTA: {acao} em queda expressiva!")
        
        elif 'negociacoes' in routing_key:
            # Processar negociação
            acao = mensagem['acao']
            quantidade = mensagem['quantidade']
            valor_total = mensagem['valor_total']
            tipo = mensagem['tipo']
            print(f"Negociação de {acao}: {tipo} de {quantidade} ações por R$ {valor_total:.2f}")
        
        # Acknowledge da mensagem (confirma o processamento)
        ch.basic_ack(delivery_tag=method.delivery_tag)
        print("Mensagem processada com sucesso!")
        
    except Exception as e:
        print(f"Erro ao processar mensagem: {e}")
        # Em caso de erro, rejeita a mensagem (não volta para a fila)
        ch.basic_nack(delivery_tag=method.delivery_tag, requeue=False)
```

### Passo 4: Configuração e Execução do Consumer

```python
def iniciar_consumer(tipo_consumer):
    """Inicia o consumer com as configurações apropriadas."""
    # URL de conexão do CloudAMQP - substitua pela sua URL
    amqp_url = 'amqp://usuario:senha@servidor.cloudamqp.com/vhost'
    
    if tipo_consumer == 'cotacoes':
        queue_name = 'cotacoes'
        binding_key = 'bolsa.cotacoes.#'
        print("Iniciando consumer de COTAÇÕES...")
    elif tipo_consumer == 'negociacoes':
        queue_name = 'negociacoes'
        binding_key = 'bolsa.negociacoes.#'
        print("Iniciando consumer de NEGOCIAÇÕES...")
    else:
        raise ValueError(f"Tipo de consumer inválido: {tipo_consumer}")
    
    # Conectar ao RabbitMQ
    connection, channel = conectar_rabbitmq(amqp_url, queue_name, binding_key)
    
    # Configurar prefetch (quantas mensagens processar de uma vez)
    channel.basic_qos(prefetch_count=1)
    
    # Configurar o consumo de mensagens
    channel.basic_consume(
        queue=queue_name,
        on_message_callback=processar_mensagem
    )
    
    print(f"Consumer {tipo_consumer} aguardando mensagens...")
    
    try:
        # Iniciar o loop de consumo
        channel.start_consuming()
    except KeyboardInterrupt:
        print("Consumer interrompido pelo usuário")
    finally:
        print("Fechando conexão...")
        channel.stop_consuming()
        connection.close()

if __name__ == "__main__":
    # Para escolher o tipo de consumer, descomente a linha desejada:
    iniciar_consumer('cotacoes')
    # iniciar_consumer('negociacoes')
```
