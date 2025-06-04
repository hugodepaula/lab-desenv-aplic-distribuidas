
# Duas maneiras de executar este script:

if (docker ps -q -f name=nginx-cache) {
	docker stop nginx-cache
}

docker-compose up --build -d

# docker-compose restart

# docker exec nginx-app nginx -t

# docker exec nginx-app nginx -s reload

# Verifica se o contêiner 'cache' existe e está em execução antes de tentar pará-lo
# if (docker ps -q -f name=cache) {
#	docker stop cache
#}

# Executa um novo contêiner Nginx com a seguinte configuração:

# docker build -t nginx-cache .
# docker run -d -p 80:80 \
#        -v ${PWD}/cache:/var/cache/nginx \
#        -v ${PWD}/static:/usr/share/nginx/static --name nginx-cache-container nginx-cache

# docker restart nginx-cache-container


