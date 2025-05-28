import redis
import json
import os
from redis.commands.json.path import Path
import redis.commands.search.aggregation as aggregations
import redis.commands.search.reducers as reducers
from redis.commands.search.field import TextField, NumericField, TagField
from redis.commands.search.index_definition import IndexDefinition, IndexType
from redis.commands.search.query import NumericFilter, Query

# Estabelece conexão com o servidor Redis local na porta padrão 6379
r = redis.Redis(host='localhost', port=6379)

def run_search_examples():
    
    # 1. Busca simples por termo - encontra todos os usuários com "Ana" no nome
    print("\n1. Busca por 'Ana':")
    result = r.ft().search("Ana")
    print(f"Encontrados {result.total} resultado(s):")
    for doc in result.docs:
        user_data = json.loads(doc.json)
        print(f"   - {user_data['user']['name']} ({user_data['user']['city']})")
    
    # 2. Busca com filtro numérico - usuários com idade entre 30 e 40 anos
    print("\n2. Busca por usuários com idade entre 30 e 40 anos:")
    q1 = Query("*").add_filter(NumericFilter("age", 30, 40))
    result = r.ft().search(q1)
    print(f"Encontrados {result.total} resultado(s):")
    for doc in result.docs:
        user_data = json.loads(doc.json)
        print(f"   - {user_data['user']['name']}, {user_data['user']['age']} anos ({user_data['user']['city']})")
    
    # 3. Busca paginada e ordenada - busca todos os usuários, retornando 3 por vez
    print("\n3. Busca paginada (3 usuários por página, ordenado por idade decrescente):")
    offset = 0  # Início da página
    num = 3     # Quantidade de resultados por página
    q = Query("*").paging(offset, num).sort_by("age", asc=False)
    result = r.ft().search(q)
    print(f"Página 1 - Mostrando {len(result.docs)} de {result.total} usuários:")
    for doc in result.docs:
        user_data = json.loads(doc.json)
        print(f"   - {user_data['user']['name']}, {user_data['user']['age']} anos")
    
    # 4. Busca por cidade específica
    print("\n4. Busca por usuários de São Paulo:")
    q2 = Query("@city:{São Paulo}")
    result = r.ft().search(q2)
    print(f"Encontrados {result.total} resultado(s):")
    for doc in result.docs:
        user_data = json.loads(doc.json)
        print(f"   - {user_data['user']['name']} ({user_data['user']['email']})")
    
    # 5. Contagem total de documentos no índice
    print("\n5. Total de documentos indexados:")
    q = Query("*").paging(0, 0)  # Retorna apenas metadados
    total_docs = r.ft().search(q).total
    print(f"Total: {total_docs} usuários no sistema")

def main():
    
    # Define o caminho do arquivo de dados
    current_dir = os.path.dirname(os.path.abspath(__file__))
    data_file = os.path.join(current_dir, 'users_data.json')
    
    # Carrega os dados dos usuários
    try:
        with open(data_file, 'r', encoding='utf-8') as file:
            data = json.load(file)
            users_data = data['users']
    except FileNotFoundError:
        print(f"Erro: Arquivo {data_file} não encontrado.")
        return []
    except json.JSONDecodeError:
        print(f"Erro: Arquivo {data_file} não é um JSON válido.")
        return []

    
    if not users_data:
        print("Nenhum dado de usuário foi carregado. Encerrando...")
        return
    
    # Limpa dados anteriores
    r.flushdb()
    
    # Insere os usuários no Redis
    for index, user_data in enumerate(users_data, 1):
        key = f"user:{index}"
        r.json().set(key, Path.root_path(), user_data)
        print(f"Usuário {user_data['user']['name']} inserido com chave: {key}")
    
    # Cria o índice de busca

    # Definição do esquema de índice para habilitar buscas eficientes
    schema = (
        TextField("$.user.name", as_name="name"),      # Campo de texto para busca por nome
        TagField("$.user.city", as_name="city"),       # Campo de tag para filtrar por cidade
        NumericField("$.user.age", as_name="age")      # Campo numérico para filtrar por idade
    )
    
    # Criação do índice no Redis
    try:
        r.ft().create_index(schema, definition=IndexDefinition(prefix=["user:"], index_type=IndexType.JSON))
        print("Índice criado com sucesso!")
    except Exception as e:
        print(f"Índice já existe ou erro na criação: {e}")
    
    # Executa exemplos de busca
    run_search_examples()

# Executa o programa principal
if __name__ == "__main__":
    main()
