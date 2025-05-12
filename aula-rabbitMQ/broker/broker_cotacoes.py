import pika
import json
import time

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

def iniciar_consumer(tipo_consumer):
    """Inicia o consumer com as configurações apropriadas."""
    # URL de conexão do CloudAMQP - substitua pela sua URL
    amqp_url = 'amqps://obbqyktj:MPxB5AqLBE3OiQfPQ5rHUj8cfeVsVsQx@shark.rmq.cloudamqp.com/obbqyktj'
    
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
