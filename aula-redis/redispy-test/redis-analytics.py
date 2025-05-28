import redis
import json
import os
from redis.commands.json.path import Path
import random

client = redis.Redis(host='localhost', port=6379)




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

    client.delete('unique_visitors')

    # Gerar uma lista com 30 números inteiros entre 1 e 22
    random_user_ids = [random.randint(1, 22) for _ in range(30)]
    print(f"IDs de usuários aleatórios gerados: {random_user_ids}")

    # Simulando acessos de usuários ao sistema
    for user_id in random_user_ids:
        # Encontrar o usuário correspondente
        user = next((item['user'] for item in users_data if item['user']['id'] == user_id), None)
        
        if user:
            # Registrar acesso no Redis
            client.pfadd('unique_visitors', str(user_id))
            print(f"Usuário {user['name']} (ID: {user_id}) de {user['city']} acessou o sistema")
        else:
            print(f"Usuário com ID {user_id} não encontrado")


    # Número estimado de visitantes únicos
    unique_count = client.pfcount('unique_visitors')
    print(f"O número de usuários únicos que acessou o sistema foi {unique_count}.")


# Executa o programa principal
if __name__ == "__main__":
    main()
