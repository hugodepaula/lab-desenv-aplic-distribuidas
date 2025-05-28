import redis
import requests
import openmeteo_requests

import pandas as pd
import requests_cache
from retry_requests import retry

# Conectar ao Redis
cache = redis.Redis(host='localhost', port=6379, db=0)

# Configurar o cliente da API Open-Meteo com cache e repetição em caso de erro
cache_session = requests_cache.CachedSession('.cache', expire_after = 3600)
retry_session = retry(cache_session, retries = 5, backoff_factor = 0.2)
openmeteo = openmeteo_requests.Client(session = retry_session)

def get_weather(city):
    cache_key = f"weather:{city}"
    
    # Verificar cache
    cached_data = cache.get(cache_key)
    if cached_data:
        print("Cache encontrado")
        return cached_data.decode('utf-8')
    
    print("Cache não encontrado. Buscando na API...")

    # Certifique-se de que todas as variáveis climáticas necessárias estão listadas aqui
    # A ordem das variáveis em hourly ou daily é importante para atribuí-las corretamente abaixo
    url = "https://api.open-meteo.com/v1/forecast"
    params = {
      "latitude": -19.9208,
      "longitude": -43.9378,
      "hourly": "temperature_2m"
    }
    responses = openmeteo.weather_api(url, params=params)
    response = responses[0]
    hourly = response.Hourly()
    hourly_temperature_2m = hourly.Variables(0).ValuesAsNumpy()

    data = hourly_temperature_2m[0]

    # Armazenar no Redis com um TTL de 60 segundos
    cache.setex(cache_key, 60, float(data))
    return data


def main():
    cache.delete(f"weather:Belo Horizonte")
    response = get_weather('Belo Horizonte')
    print(response)
    response = get_weather('Belo Horizonte')
    print(response)

 

# Executa o programa principal
if __name__ == "__main__":
    main()
