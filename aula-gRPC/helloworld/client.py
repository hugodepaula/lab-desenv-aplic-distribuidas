import logging
import grpc
import helloworld.helloworld_pb2 as helloworld_pb2
import helloworld.helloworld_pb2_grpc as helloworld_pb2_grpc

def run():
    # Configura a conexão com o servidor
    with grpc.insecure_channel('localhost:50051') as channel:
        stub = helloworld_pb2_grpc.GreeterStub(channel)
        
        # Chamada RPC simples
        print("=== Chamada Simples ===")
        response = stub.SayHello(helloworld_pb2.HelloRequest(name="Alice"))
        print(f"Resposta: {response.message}")
        print(f"Tags: {response.tags}")
        
        # Chamada com streaming de resposta
        print("\n=== Streaming de Resposta ===")
        responses = stub.LotsOfReplies(helloworld_pb2.HelloRequest(name="Bob"))
        for response in responses:
            print(f"Resposta: {response.message}")
        
        # Chamada com streaming de requisição
        print("\n=== Streaming de Requisição ===")
        def generate_requests():
            names = ["Carol", "Dave", "Eve"]
            for name in names:
                yield helloworld_pb2.HelloRequest(name=name)
        response = stub.LotsOfGreetings(generate_requests())
        print(f"Resposta combinada: {response.message}")
        
        # Chamada bidirecional
        print("\n=== Streaming Bidirecional ===")
        def generate_bidi_requests():
            names = ["Frank", "Grace", "Heidi"]
            for name in names:
                yield helloworld_pb2.HelloRequest(name=name)
        responses = stub.BidiHello(generate_bidi_requests())
        for response in responses:
            print(f"Resposta: {response.message}")

if __name__ == '__main__':
    logging.basicConfig()
    run()