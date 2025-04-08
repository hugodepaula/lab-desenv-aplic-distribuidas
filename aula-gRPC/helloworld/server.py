from concurrent import futures
import logging
import grpc
import helloworld.helloworld_pb2 as helloworld_pb2
import helloworld.helloworld_pb2_grpc as helloworld_pb2_grpc

class Greeter(helloworld_pb2_grpc.GreeterServicer):
    def SayHello(self, request, context):
        return helloworld_pb2.HelloReply(
            message=f"Hello, {request.name}!",
            tags=["welcome", "new_user"]
        )
    
    def LotsOfReplies(self, request, context):
        for i in range(5):
            yield helloworld_pb2.HelloReply(
                message=f"Hello {request.name} (response {i+1})"
            )
    
    def LotsOfGreetings(self, request_iterator, context):
        names = []
        for request in request_iterator:
            names.append(request.name)
        return helloworld_pb2.HelloReply(
            message=f"Hello to all: {', '.join(names)}"
        )
    
    def BidiHello(self, request_iterator, context):
        for request in request_iterator:
            yield helloworld_pb2.HelloReply(
                message=f"Hello, {request.name}!"
            )

def serve():
    # Cria um servidor com 10 threads de worker
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    
    # Adiciona o serviço ao servidor
    helloworld_pb2_grpc.add_GreeterServicer_to_server(Greeter(), server)
    
    # Configura a porta (com autenticação SSL opcional)
    server.add_insecure_port('[::]:50051')
    
    # Inicia o servidor
    server.start()
    print("Servidor gRPC rodando na porta 50051...")
    
    # Mantém o servidor ativo
    server.wait_for_termination()

if __name__ == '__main__':
    logging.basicConfig()
    serve()