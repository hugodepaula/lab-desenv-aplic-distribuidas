# Este script para e inicia um contêiner de servidor web Nginx

# Verifica se o contêiner 'web' existe e está em execução antes de tentar pará-lo
if (docker ps -q -f name=web) {
	docker stop web
}

# Executa um novo contêiner Nginx com a seguinte configuração:

# -v "${PWD}/site-content:/usr/share/nginx/html": Monta o diretório local site-content no diretório HTML do Nginx

docker run -it --rm -d -p 8080:80 --name web -v "${PWD}/site-content:/usr/share/nginx/html" nginx
