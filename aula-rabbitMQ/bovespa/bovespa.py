# Publisher

import pika
import json
import time
import random

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

def simular_bolsa():
    """Simula um producer enviando dados da bolsa de valores."""
    # URL de conexão do CloudAMQP - substitua pela sua URL
    amqp_url = 'amqps://obbqyktj:MPxB5AqLBE3OiQfPQ5rHUj8cfeVsVsQx@shark.rmq.cloudamqp.com/obbqyktj'
    
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