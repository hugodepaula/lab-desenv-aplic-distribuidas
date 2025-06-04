# Roteiro de Cache e Balanceamento de Carga com NGINX

## Fundamentos do NGINX

O NGINX (Engine X) constitui um servidor web de código aberto que opera como servidor web, proxy reverso, balanceador de carga e servidor de cache.

- O servidor web representa um software que processa requisições HTTP e fornece conteúdo para clientes.
- O proxy reverso atua como intermediário entre clientes e servidores backend, recebendo requisições dos clientes e encaminhando-as para servidores apropriados.
- O balanceador de carga distribui requisições entre múltiplos servidores para otimizar utilização de recursos e garantir alta disponibilidade.

### Arquitetura Master-Worker do NGINX

A arquitetura do NGINX baseia-se no modelo master-worker. O processo master executa com privilégios de root e realiza operações privilegiadas como leitura de configuração, ligação a portas e gerenciamento de processos worker.

Os processos worker operam com privilégios reduzidos e processam requisições de clientes. Cada worker utiliza um modelo orientado por eventos não-bloqueante que permite o gerenciamento de milhares de conexões simultâneas através de um único thread.

![Modelo de Processos do NGINX](NGINX_process-model.png)

Para saber detalhes do modelo de processos do NGINX, sugiro: <https://blog.nginx.org/blog/inside-nginx-how-we-designed-for-performance-scale>

## Executando o NGINX web server

Para executar um servidor "limpo" em um contêiner:

```bash
docker run -it --rm -d -p 8080:80 --name web nginx
```

Para especificar um conteúdo de um site para ser servido:

```bash
docker run -it --rm -d -p 8080:80 --name web -v ~/site-content:/usr/share/nginx/html nginx
```

Opções do `docker run`

1. `-it`: Combina duas flags:
    1. `-i` (interativo): Mantém o STDIN aberto
    1. `-t` (tty): Aloca um pseudo-TTY
1. `--rm`: Remove automaticamente o contêiner quando ele for finalizado
1. `-d`: Executa o contêiner em modo destacado (background)
1. `-p 8080:80`: Mapeia a porta 8080 do host para a porta 80 do contêiner (onde o Nginx escuta)
1. `--name web`: Define o nome do contêiner como "web"
1. `-v ~/site-content:/usr/share/nginx/html`: Monta o diretório local ~/site-content no caminho /usr/share/nginx/html dentro do contêiner (onde o Nginx serve os arquivos)
1. `nginx`: A imagem Docker a ser utilizada

Pra mais informações: <https://www.docker.com/blog/how-to-use-the-official-nginx-docker-image/>

## Cache de Conteúdo no NGINX

### Configuração Básica de Cache

A habilitação de cache requer duas diretivas principais: `proxy_cache_path` e `proxy_cache`. A diretiva `proxy_cache_path` define o caminho e configuração do cache, enquanto `proxy_cache` ativa o cache.

```nginx
proxy_cache_path /caminho/para/cache levels=1:2 
                 keys_zone=meu_cache:10m max_size=10g 
                 inactive=60m use_temp_path=off;

server {
    location / {
        proxy_cache meu_cache;
        proxy_pass http://meu_upstream;
    }
}
```

Os parâmetros da diretiva `proxy_cache_path` define:

- O diretório local no disco para o cache
- `levels` estabelece hierarquia de diretórios de dois níveis
- `keys_zone` configura zona de memória compartilhada para armazenar chaves de cache e metadados
- `max_size` limita o tamanho total do cache
- `inactive` define tempo para remoção de conteúdo não acessado
- `use_temp_path=off` instrui o NGINX a escrever diretamente no diretório de cache


### Microcache e Controle de Validade

O microcache representa uma técnica onde conteúdo é armazenado por períodos muito curtos, tipicamente segundos. Usado para conteúdo dinâmico que muda frequentemente mas pode ser servido do cache.

```nginx
proxy_cache_path /tmp/cache keys_zone=cache:10m 
                 levels=1:2 inactive=600s max_size=100m;

server {
    proxy_cache cache;
    proxy_cache_valid 200 1s;
}
```

A diretiva `proxy_cache_valid` especifica que respostas com código 200 serão armazenadas por 1 segundo. O parâmetro `inactive` remove conteúdo não acessado por 600 segundos (10 minutos) independentemente de estar obsoleto.

## Balanceamento de Carga com NGINX

### Algoritmos de Balanceamento

O NGINX implementa diversos algoritmos de balanceamento de carga categorizados em estáticos e dinâmicos.

- Algoritmos estáticos não utilizam informações sobre o estado do sistema para decisões de distribuição.
- Algoritmos dinâmicos consideram estados de carga do sistema para distribuição mais justa.

#### Algoritmos Estáticos

O **Round Robin** constitui o algoritmo padrão que atribui requisições sequencialmente com base no grupo de servidores disponíveis[^3]. As requisições são distribuídas em ordem circular entre os servidores configurados.

```nginx
upstream backend {
    server backend1.exemplo.com;
    server backend2.exemplo.com;
    server backend3.exemplo.com;
}
```

O **Weighted Round Robin** permite atribuir pesos diferentes aos servidores baseado em sua capacidade. Servidores com maior peso recebem proporcionalmente mais requisições.

```nginx
upstream backend {
    server backend1.exemplo.com weight=3;
    server backend2.exemplo.com weight=1;
    server backend3.exemplo.com weight=1;
}
```

O **IP Hash** mantém requisições de um cliente direcionadas sempre para o mesmo servidor. O algoritmo calcula hash do endereço IP do cliente para determinar o servidor de destino, garantindo persistência de sessão.

#### Algoritmos Dinâmicos

O **Least Connections** consulta informações sobre número de conexões ativas em cada servidor disponível. O balanceador distribui a próxima requisição para o servidor com menor carga no momento.

O **Weighted Least Connections** combina informações de conexões ativas com pesos configurados. O cálculo utiliza a razão entre número de conexões ativas e peso atribuído para determinar o servidor de destino.

```nginx
http {
    upstream aplicacao_backend {
        least_conn;
        server app1.exemplo.com weight=3;
        server app2.exemplo.com weight=2;
        server app3.exemplo.com backup;
    }
    
    server {
        location / {
            proxy_pass http://aplicacao_backend;
        }
    }
}
```

O servidor marcado como `backup` recebe requisições apenas quando servidores primários estão indisponíveis.

