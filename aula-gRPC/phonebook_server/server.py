from concurrent import futures
import grpc
import phonebook_pb2
import phonebook_pb2_grpc

class Phonebook:
    def __init__(self):
        self.entries = {
            "Vítor Araujo": "(38) 1683-2824",
            "Márcio Teixeira": "(96) 2554-7858",
            "Thiago Sousa": "(24) 6732-4569",
            "Diego Almeida": "(38) 4423-2776",
            "Júlio do Nascimento": "(21) 1686-3487",
            "Raimundo Machado": "(25) 3947-6578",
            "Felipe Gonçalves": "(47) 1871-7863",
            "Alex Almeida": "(85) 5377-7335",
            "Francisco Batista": "(67) 3236-8885",
            "Matheus Nunes": "(41) 8127-7758",
            "André Borges": "(95) 2854-5188",
            "Antônio dos Santos": "(51) 3934-2538",
            "Marcos Gonçalves": "(56) 2773-7748",
            "Gustavo Dias": "(28) 5223-6669",
            "Luíz Santana": "(78) 9663-3858",
            "Francisco Costa": "(13) 6747-4213",
            "Leandro Lopes": "(45) 3328-7387",
            "Guilherme Lima": "(33) 4912-6854",
            "Ânderson Almeida": "(17) 4949-7835",
            "José da Silva": "(95) 4475-8123",
            "Carlos Oliveira": "(21) 7527-4445",
            "Diego Ferreira": "(27) 9945-2542",
            "Ricardo de Lima": "(34) 5442-1662",
            "Vítor Mendes": "(61) 5187-8881",
            "Mateus da Silva": "(62) 8717-8224",
            "Luciano de Oliveira": "(66) 8582-3838",
            "Alexandre Sousa": "(33) 4573-6432",
            "Renato Pereira": "(41) 6238-6323",
            "Sérgio da Costa": "(22) 4443-1635",
            "André Gonçalves": "(37) 9235-5162",
            "Bruno Nunes": "(47) 7669-4235",
            "Roberto Santos": "(45) 3569-7744"
        }

class PhonebookService(phonebook_pb2_grpc.PhonebookServiceServicer):
    def __init__(self):
        self.phonebook = Phonebook()

    def LookupNumber(self, request, context):
        name = request.name
        phone_number = self.phonebook.entries.get(name, "")
        return phonebook_pb2.LookupResponse(
            name=name,
            phone_number=phone_number,
            found=phone_number != ""
        )

def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    phonebook_pb2_grpc.add_PhonebookServiceServicer_to_server(
        PhonebookService(), server)
    server.add_insecure_port('[::]:50051')
    server.start()
    print("Catálogo de telefone executando na porta 50051...")
    server.wait_for_termination()

if __name__ == '__main__':
    serve()
