# Roteiro de Trabalho: Introdução a Java Sockets TCP

Este roteiro apresenta um guia passo a passo para aprender os conceitos básicos de programação com sockets TCP em Java ao passo que apresenta a base para a arquitetura de microsserviços. O objetivo é criar um servidor e um cliente que se comuniquem continuamente, suportem múltiplos clientes e incluam endpoints RESTful.

---

## **Problema Proposto**

Crie uma aplicação de chat simples onde:

- O servidor aceita conexões de múltiplos clientes.
- Os clientes podem enviar mensagens para o servidor.
- O servidor devolve as mensagens recebidas em letras maiúsculas.
- O servidor expõe um endpoint REST que retorna o número de clientes conectados.

---

## **Criando o Servidor**

O servidor TCP utiliza sockets para aceitar conexões de clientes.

O método `Executors.newCachedThreadPool()` cria um pool de threads que se ajusta dinamicamente de acordo com a carga de trabalho. Ele cria novas threads conforme necessário, mas reutiliza threads previamente construídas quando estão disponíveis.

O servidor será responsável por:

1. Escutar conexões na porta especificada.
2. Criar uma nova thread para cada cliente conectado usando o pool de threads.
3. Manter a comunicação contínua com os clientes.

### **Código do Servidor**

```java
import java.io.*;
import java.net.*;
import java.util.concurrent.*;

public class ChatServer {

  private static final int PORT = 16001;
  private static final ExecutorService pool = Executors.newCachedThreadPool();

  private static int clientCount = 0;

  public static void main(String[] args) throws IOException {
    ServerSocket serverSocket = null;
    try {
      // Criação do socket do servidor para escutar conexões
      serverSocket = new ServerSocket(PORT);
      System.out.println("Servidor TCP na porta " + PORT);

      // Loop infinito para aceitar conexões
      while (true) {
        // Aceita uma conexão de cliente
        Socket clientSocket = serverSocket.accept();

        // Incrementa o contador de clientes conectados
        // synchronized gera um lock (trava) para a classe ChatServer,
        // de modo que ela não poderá ser acessada concorrentemente
        // Isto faz sentido porque os atributos são estáticos
        synchronized (ChatServer.class) {
          clientCount++;
        }

        System.out.println("Novo cliente conectado: " + clientSocket.getRemoteSocketAddress());
        // Processa o cliente em uma nova thread
        // Se houver threads ociosas ele reaproveita a thread,
        // caso contrário ele cria uma nova
        pool.execute(new ClientHandler(clientSocket));
      }
    } catch (Exception e) {
      System.out.println(e.getMessage());
    } finally {
      if (serverSocket != null) {
        serverSocket.close();
      }
    }
  }

  // Método sincronizado para obter o número de clientes conectados
  public static synchronized int getClientCount() {
    return clientCount;
  }

  // Método sincronizado para decrementar o número de clientes conectados
  public static synchronized void decrementClientCount() {
    clientCount--;
  }
}

// Classe que gerencia a comunicação com um cliente específico
class ClientHandler implements Runnable {
  private final Socket clientSocket;

  public ClientHandler(Socket socket) {
    this.clientSocket = socket;
  }

  @Override
  public void run() {

    // Utilizando try-catch com auto-close, ou seja, o BufferedReader
    // e o PrintWriter serão automaticamente fechados após o bloco try-catch
    try (
        BufferedReader in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
        PrintWriter out = new PrintWriter(clientSocket.getOutputStream(), true)) {
      String message;
      // Lê mensagens do cliente até que ele desconecte
      while ((message = in.readLine()) != null) {
        System.out.println("Mensagem recebida: " + message);
        out.println(message.toUpperCase());
      }
    } catch (IOException e) {
      System.out.println(e.getMessage());
    } finally {
      try {
        // Fecha a conexão com o cliente
        clientSocket.close();
        ChatServer.decrementClientCount();
      } catch (IOException e) {
        e.printStackTrace();
      }
    }
  }
}
```

---

## **Criando o Cliente**

O cliente spermite que o usuário digite mensagens no terminal e visualize as respostas do servidor.

### **Código do Cliente**

```java
import java.io.*;
import java.net.*;

public class ChatClient {
  private static final String SERVER_ADDRESS = "localhost";
  private static final int SERVER_PORT = 16001;

  public static void main(String[] args) throws IOException {
    // try-catch com auto-close. Conexão e buffer de leitura/escrita 
    // serão fechados automaticamente após o try-catch
    try (
        // Conexão com o servidor
        Socket socket = new Socket(SERVER_ADDRESS, SERVER_PORT);
        BufferedReader userInput = new BufferedReader(new InputStreamReader(System.in)); 
        PrintWriter out = new PrintWriter(socket.getOutputStream(), true); // Envio de dados ao servidor
        BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream())) // Recebimento de dados
    ) {

      System.out.println("Conectado ao servidor. Digite suas mensagens:");

      String input;
      while ((input = userInput.readLine()) != null) {
        // Envia a mensagem digitada pelo usuário ao servidor
        out.println(input); 
        // Exibe a resposta recebida do servidor
        System.out.println("Resposta do servidor: " + in.readLine()); 
      }
    }
  }
}
```

## **Testando a Solução**

1. Compile os programas:

   ```bash
   # Na pasta do projeto do servidor
   javac ChatServer.java 

   # Na pasta do projeto do cliente
   javac ChatClient.java
   ```

2. Execute o servidor:

   ```bash
   java ChatServer
   ```

3. Execute múltiplos clientes:

   ```bash
   java ChatClient
   ```

---

## **Virtual Threads em Java**

### **O que são Virtual Threads?**

Virtual Threads são uma alternativa leve às threads tradicionais (*Platform Threads*). Enquanto as threads tradicionais são gerenciadas pelo sistema operacional e possuem um alto custo de criação e gerenciamento, Virtual Threads são gerenciadas pela JVM, permitindo a execução de milhões de threads simultaneamente com baixo consumo de memória e recursos.

### **Vantagens das Virtual Threads**

1. **Baixo consumo de memória**: Virtual Threads utilizam apenas alguns kilobytes por thread, enquanto as threads tradicionais podem consumir até 1 MB cada.

2. **Escalabilidade**: Permitem criar milhões de threads, enquanto as threads tradicionais são limitadas a milhares.

3. **Eficiência em operações bloqueantes**: Em operações como I/O (entrada/saída), as Virtual Threads liberam o *carrier thread* (thread da plataforma) enquanto aguardam.

4. **Simplificação do código**: Eliminam a necessidade de modelos assíncronos complexos, como APIs reativas.

### **Alterando o ChatServer para Suportar Virtual Threads**

A principal mudança será substituir o uso de `ExecutorService` com um pool tradicional por um executor baseado em Virtual Threads. Isso simplifica o gerenciamento de concorrência e aumenta a escalabilidade do servidor.

### **Código Modificado do Servidor**

```java
import java.io.*;
import java.net.*;
import java.util.concurrent.*;

public class ChatServer {

  private static final int PORT = 16001;

  // Executor baseado em Virtual Threads
  private static final ExecutorService virtualThreadExecutor = Executors.newVirtualThreadPerTaskExecutor();

  private static int clientCount = 0;

  public static void main(String[] args) throws IOException {
    ServerSocket serverSocket = null;
    try {
      serverSocket = new ServerSocket(PORT);
      System.out.println("Servidor TCP na porta " + PORT);

      while (true) {
        // Aceita uma conexão de cliente
        Socket clientSocket = serverSocket.accept();

        synchronized (ChatServer.class) {
          clientCount++;
        }

        System.out.println("Novo cliente conectado: " + clientSocket.getRemoteSocketAddress());
        // Cria uma nova virtual thread para cada task. 
        // O número máximo de virtual threads é ilimitado
        virtualThreadExecutor.execute(new ClientHandler(clientSocket));
      }
    } catch (Exception e) {
      System.out.println(e.getMessage());
    } finally {
      if (serverSocket != null) {
        serverSocket.close();
      }
    }
  }

  public static synchronized int getClientCount() {
    return clientCount;
  }

  public static synchronized void decrementClientCount() {
    clientCount--;
  }
}

class ClientHandler implements Runnable {
  private final Socket clientSocket;

  public ClientHandler(Socket socket) {
    this.clientSocket = socket;
  }

  @Override
  public void run() {

    try (
        BufferedReader in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
        PrintWriter out = new PrintWriter(clientSocket.getOutputStream(), true)) {
      String message;
      // Lê mensagens do cliente até que ele desconecte
      while ((message = in.readLine()) != null) {
        System.out.println("Mensagem recebida: " + message);
        out.println(message.toUpperCase());
      }
    } catch (IOException e) {
      System.out.println(e.getMessage());
    } finally {
      try {
        // Fecha a conexão com o cliente
        clientSocket.close();
        ChatServer.decrementClientCount();
      } catch (IOException e) {
        e.printStackTrace();
      }
    }
  }
}
```

## Segurança em Redes  

Vamos usar a implementação de SSL/TLS para proteger a comunicação entre o cliente e o servidor.

### O que é SSL/TLS?

SSL (*Secure Sockets Layer_) e TLS (*Transport Layer Security*) são protocolos de segurança que criptografam a comunicação entre um cliente e um servidor. Eles garantem a confidencialidade, integridade e autenticidade dos dados transmitidos.

### Criando um Keystore em Java  

Primeiramente é necessário criar um keystore, que é um repositório seguro para armazenar chaves criptográficas e certificados. O keystore é usado para autenticar o servidor e, opcionalmente, o cliente.
Para criar um keystore em Java, você pode usar a ferramenta `keytool`, incluída no JDK. Essa ferramenta permite gerenciar chaves e certificados.  

### Passos para Criar um Keystore  

**Gerar Keystore:**  

```bash  
keytool -genkey -alias chatserver -keyalg RSA -keystore keystore.jks -keysize 2048 -validity 365    
```  

Esse comando gera um novo par de chaves pública/privada em um arquivo de keystore chamado `keystore.jks` com um alias `chatserver` usando o algoritmo de chave RSA. O tamanho da chave é definido como 2048 bits. O parâmetro de validade o torna um certificado auto-assinado com validade de 365 dias. O keystore é protegido por uma senha, que deve ser fornecida durante a criação e ao acessar o keystore posteriormente no programa Java. Considerações importantes:  

- Certifique-se de que os nomes dos aliases sejam únicos dentro do keystore.  
- Mantenha a senha do keystore em segurança.  
- Utilize algoritmos de criptografia robustos e tamanhos de chave maiores para melhor segurança.  

### Implementando SSL/TLS em Aplicações Java  

Java oferece suporte a SSL/TLS por meio do pacote `javax.net.ssl`. Você pode criar sockets seguros usando as classes `SSLSocket` e `SSLServerSocket`.  

### **Código do Servidor seguro**

```java
import javax.net.ssl.KeyManagerFactory;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLServerSocket;
import javax.net.ssl.SSLServerSocketFactory;
import javax.net.ssl.SSLSocket;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.security.KeyStore;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class ChatSecureServer {

  private static final int PORT = 16001;
  private static final ExecutorService virtualThreadExecutor = Executors.newVirtualThreadPerTaskExecutor();

  private static int clientCount = 0;

  public static void main(String[] args) throws IOException {

    // Declaração do socket seguro do servidor
    SSLServerSocket serverSocket = null;

    try {
      // Carrega o arquivo de keystore que contém o certificado e a chave privada do
      // servidor
      KeyStore keyStore = KeyStore.getInstance("JKS");
      keyStore.load(new FileInputStream("keystore.jks"), "shulambs".toCharArray());

      // Inicializa o gerenciador de chaves com o keystore
      KeyManagerFactory kmf = KeyManagerFactory.getInstance(KeyManagerFactory.getDefaultAlgorithm());
      kmf.init(keyStore, "shulambs".toCharArray());

      // Configura o contexto SSL com os gerenciadores de chaves
      SSLContext sslContext = SSLContext.getInstance("TLS");
      sslContext.init(kmf.getKeyManagers(), null, null);

      // Cria uma fábrica de sockets SSL usando o contexto configurado
      SSLServerSocketFactory ssf = sslContext.getServerSocketFactory();

      // Criação do socket seguro do servidor para escutar conexões
      serverSocket = (SSLServerSocket) ssf.createServerSocket(PORT);

      System.out.println("Servidor TCP seguro (SSL/TLS) na porta " + PORT);

      // Loop infinito para aceitar conexões
      while (true) {
        // Aceita uma conexão de cliente e retorna um socket SSL para comunicação
        SSLSocket clientSocket = (SSLSocket) serverSocket.accept();

        synchronized (ChatSecureServer.class) {
          clientCount++;
        }

        System.out.println("Novo cliente conectado: " + clientSocket.getRemoteSocketAddress());

        virtualThreadExecutor.execute(new ClientHandler(clientSocket));
      }
    } catch (Exception e) {
      System.out.println(e.getMessage());
    } finally {
      if (serverSocket != null) {
        serverSocket.close();
      }
    }
  }

  // Método sincronizado para obter o número de clientes conectados
  public static synchronized int getClientCount() {
    return clientCount;
  }

  // Método sincronizado para decrementar o número de clientes conectados
  public static synchronized void decrementClientCount() {
    clientCount--;
  }
}

// Classe que gerencia a comunicação com um cliente específico
class ClientHandler implements Runnable {
  private final Socket clientSocket;

  public ClientHandler(Socket socket) {
    this.clientSocket = socket;
  }

  @Override
  public void run() {

    // Utilizando try-catch com auto-close, ou seja, o BufferedReader
    // e o PrintWriter serão automaticamente fechados após o bloco try-catch
    try (
        BufferedReader in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
        PrintWriter out = new PrintWriter(clientSocket.getOutputStream(), true)) {

      String message;
      // Lê mensagens do cliente até que ele desconecte
      while ((message = in.readLine()) != null) {
        System.out.println("Mensagem recebida: " + message);
        out.println(message.toUpperCase());
      }
    } catch (IOException e) {
      System.out.println(e.getMessage());
    } finally {
      try {
        // Fecha a conexão com o cliente
        clientSocket.close();
        ChatSecureServer.decrementClientCount();
      } catch (IOException e) {
        e.printStackTrace();
      }
    }
  }
} 
```

### **Código do Cliente seguro**

```java
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.security.KeyStore;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManagerFactory;

public class ChatSecureClient {
  private static final String SERVER_ADDRESS = "localhost";
  private static final int SERVER_PORT = 16001;

  public static void main(String[] args) throws IOException {

    // Socket SSL para comunicação segura com o servidor
    SSLSocket socket = null;
    try (BufferedReader userInput = new BufferedReader(new InputStreamReader(System.in));) {

      // Carrega o keystore com certificados confiáveis
      KeyStore keyStore = KeyStore.getInstance("JKS");
      keyStore.load(new FileInputStream("keystore.jks"), "shulambs".toCharArray());

      // Inicializa o gerenciador de confiança com o keystore
      TrustManagerFactory tmf = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
      tmf.init(keyStore);

      // Configura o contexto SSL com os gerenciadores de confiança
      SSLContext sslContext = SSLContext.getInstance("TLS");
      sslContext.init(null, tmf.getTrustManagers(), null);

      // Cria uma fábrica de sockets SSL e conecta ao servidor
      SSLSocketFactory ssf = sslContext.getSocketFactory();
      socket = (SSLSocket) ssf.createSocket(SERVER_ADDRESS, SERVER_PORT);

      // Inicializa streams para envio e recebimento de dados
      PrintWriter out = new PrintWriter(socket.getOutputStream(), true); // Envio de dados ao servidor
      BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream())); // Recebimento de dados

      System.out.println("Conectado ao servidor. Digite suas mensagens:");

      // Loop principal de comunicação
      String input;
      while ((input = userInput.readLine()) != null) {
      // Envia a mensagem digitada pelo usuário ao servidor
      out.println(input); 
      // Exibe a resposta recebida do servidor
      System.out.println("Resposta do servidor: " + in.readLine()); 
      }
      in.close();
      out.close();
    } catch (Exception e) {
      System.out.println(e.getMessage());
    } finally {
      if (socket != null) {
        socket.close();
      }
    }
  }
}
```

## Programação com WebSocket  

Os WebSockets fornecem um canal de comunicação full-duplex sobre uma única conexão de longa duração, permitindo interação em tempo real entre clientes e servidores. Isso representa uma melhoria significativa em relação ao HTTP tradicional, onde uma nova conexão é estabelecida para cada par de requisição/resposta e provê uma solução de mais alto nível que a programação em Sockets TCP.  

Diferenças entre WebSockets e Sockets TCP tradicionais:  

- **WebSockets:** Comunicação baseada na web, full-duplex sobre uma única conexão TCP.  
- **Sockets Tradicionais:** Comunicação de rede de propósito geral, normalmente usadas para tarefas de rede de baixo nível.  
- **Protocolo**: WebSockets usam o protocolo ```ws://``` ou ```wss://``` (para versão segura) em vez de TCP puro.
- **Conexão Persistente**: Ao contrário do HTTP tradicional, WebSockets mantêm a conexão aberta para comunicação bidirecional.
- **API de Nível Mais Alto**: A API WebSocket abstrai muitos detalhes de baixo nível da comunicação por sockets.
- **Integração com HTTP**: WebSockets iniciam como uma conexão HTTP e depois fazem upgrade para WebSocket.

### WebSockets em Java

Em Java, uilizamos a API Java para WebSocket (JSR 356). Componentes da API:
Esta API Java fornece componentes do lado do servidor e do cliente:

- *server-side*: pacote ```jakarta.websocket.server```
- *client-side*: pacote ```jakarta.websocket```

Dependência Maven:

```xml
<dependency>
    <groupId>jakarta.websocket</groupId>
    <artifactId>jakarta.websocket-api</artifactId>
    <version>2.2.0</version>
</dependency>
```

#### Configuração do endpoint com *annotations*

*Annotations* do WebSocket:

- ```@ServerEndpoint```: garante a disponibilidade da classe como um servidor WebSocket escutando um URI específico.
- ```@ClientEndpoint```: a classe com essa anotação é tratada como um cliente WebSocket.
- ```@OnOpen```: chamado quando uma nova conexão WebSocket é iniciada.
- ```@OnMessage```: método que recebe as informações do WebSocket.
- ```@OnError```: é invocado quando há um problema com a comunicação.
- ```@OnClose```: chamado quando a conexão WebSocket é fechada.

### Servidor WebSocket  

```java  
package br.ldamd;

import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.atomic.AtomicInteger;

// Servidor Chat WebSocket com broadcast na transmissão de mensagens.
@ServerEndpoint("/chat")
public class WebSocketChatServer {
  // Conjunto thread-safe para armazenar todas as sessões de clientes ativas
  private static final Set<Session> sessions = Collections.synchronizedSet(new HashSet<>());
  // Contador atômico para acompanhar o número de clientes conectados
  private static final AtomicInteger clientCount = new AtomicInteger(0);

  // Gerencia novas conexões WebSocket.
  @OnOpen
  public void onOpen(Session session) {
    sessions.add(session);
    int count = clientCount.incrementAndGet();
    System.out.println("Novo cliente conectado. Total: " + count);
    
    try {
      session.getBasicRemote().sendText("Bem-vindo ao chat! Você é o cliente #" + count);
      broadcast("Cliente #" + count + " entrou no chat");
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  // Processa mensagens recebidas dos clientes.
  @OnMessage
  public void onMessage(String message, Session session) {
    System.out.println("Mensagem recebida: " + message);
    
    // Converte a mensagem para maiúsculas
    String response = message.toUpperCase();
    
    try {
      // Envia confirmação de volta ao remetente
      session.getBasicRemote().sendText("Você disse: " + response);
      
      // Transmite a mensagem original para todos os outros clientes
      broadcast("Cliente diz: " + message, session);
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  // Gerencia desconexões de clientes.
  @OnClose
  public void onClose(Session session) {
    sessions.remove(session);
    int count = clientCount.decrementAndGet();
    System.out.println("Cliente desconectado. Total restante: " + count);
    broadcast("Um cliente saiu do chat. Total online: " + count);
  }

  @OnError
  public void onError(Session session, Throwable throwable) {
    System.err.println("Erro na conexão: " + throwable.getMessage());
    sessions.remove(session);
    clientCount.decrementAndGet();
  }

  // Envia uma mensagem para todos os clientes conectados.
  private static void broadcast(String message) {
    synchronized (sessions) {
      for (Session s : sessions) {
        if (s.isOpen()) {
          try {
            s.getBasicRemote().sendText(message);
          } catch (IOException e) {
            e.printStackTrace();
          }
        }
      }
    }
  }

  // Envia uma mensagem para todos os clientes conectados exceto o especificado.
  private static void broadcast(String message, Session excludeSession) {
    synchronized (sessions) {
      for (Session s : sessions) {
        if (s.isOpen() && !s.equals(excludeSession)) {
          try {
            s.getBasicRemote().sendText(message);
          } catch (IOException e) {
            e.printStackTrace();
          }
        }
      }
    }
  }

  public static int getClientCount() {
    return clientCount.get();
  }
}
```  

### Cliente WebSocket  

```java  
package br.ldamd;

import jakarta.websocket.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URI;

@ClientEndpoint
public class WebSocketChatClient {
    private Session session;
    private BufferedReader userInput;

    @OnOpen
    public void onOpen(Session session) {
        this.session = session;
        System.out.println("Conectado ao servidor de chat");
    }

    @OnMessage
    public void onMessage(String message) {
        System.out.println("Servidor diz: " + message);
    }

    @OnClose
    public void onClose() {
        System.out.println("Conexão com o servidor encerrada");
    }

    @OnError
    public void onError(Throwable throwable) {
        System.err.println("Erro na conexão: " + throwable.getMessage());
    }

    public void sendMessage(String message) {
        try {
            session.getBasicRemote().sendText(message);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        try {
            WebSocketContainer container = ContainerProvider.getWebSocketContainer();
            WebSocketChatClient client = new WebSocketChatClient();
            
            // Conecta ao servidor WebSocket
            container.connectToServer(client, URI.create("ws://localhost:8080/chat"));
            
            // Configura leitura de entrada do usuário
            client.userInput = new BufferedReader(new InputStreamReader(System.in));
            System.out.println("Digite suas mensagens (ou 'sair' para desconectar):");
            
            String input;
            while ((input = client.userInput.readLine()) != null) {
                if ("sair".equalsIgnoreCase(input)) {
                    client.session.close();
                    break;
                }
                client.sendMessage(input);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

### WebSockets Seguros com SSL

WSS (*WebSocket Secure*) é a versão criptografada do protocolo WebSocket que utiliza TLS/SSL para garantir comunicação segura entre cliente e servidor. Ele funciona sobre o esquema ```wss://```.

Para implementar WSS em Java, utilizamos a API Jakarta WebSocket com configurações SSL/TLS. As principais classes e anotações envolvidas são:

- ```@ServerEndpoint```: Define o endpoint do servidor WebSocket, agora com o esquema wss://.
- ```SSLContext```: Configura o contexto SSL para criptografia.
- ```ServerContainer```: Permite configurar propriedades SSL para o servidor WebSocket.
- ```WebSocketContainer```: No cliente, configura a conexão segura com o servidor WSS.

Além disso, é necessário um keystore (como no exemplo anterior de SSL/TLS) para armazenar o certificado do servidor.

### Servidor WebSocket Seguro

```java
package br.ldamd;

import jakarta.websocket.*;
import jakarta.websocket.server.HandshakeRequest;
import jakarta.websocket.server.ServerEndpointConfig;

// Configurador SSL
public class SecureServerConfigurator extends ServerEndpointConfig.Configurator {
  @Override
  public void modifyHandshake(ServerEndpointConfig sec, HandshakeRequest request, HandshakeResponse response) {
    super.modifyHandshake(sec, request, response);
    // Configurações de segurança adicionais

  }

  @Override
  public boolean checkOrigin(String originHeaderValue) {
    return true; // Aceita todas as origens (em produção, restrinja isso)
  }
}
```

```java
package br.ldamd;

import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.atomic.AtomicInteger;

// Servidor Chat WebSocket seguro, baseado no SecureServerConfiguration
@ServerEndpoint(value = "/securechat", configurator = SecureServerConfigurator.class)
public class WssChatServer {
  // Conjunto thread-safe para armazenar todas as sessões de clientes ativas
  private static final Set<Session> sessions = Collections.synchronizedSet(new HashSet<>());
  // Contador atômico para acompanhar o número de clientes conectados
  private static final AtomicInteger clientCount = new AtomicInteger(0);

  // Gerencia novas conexões WebSocket.
  @OnOpen
  public void onOpen(Session session) {
    sessions.add(session);
    int count = clientCount.incrementAndGet();
    System.out.println("Novo cliente seguro conectado. Total: " + count);
    
    try {
      session.getBasicRemote().sendText("Bem-vindo ao chat! Você é o cliente #" + count);
      broadcast("Cliente #" + count + " entrou no chat");
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  // Processa mensagens recebidas dos clientes.
  @OnMessage
  public void onMessage(String message, Session session) {
    System.out.println("Mensagem recebida: " + message);
    
    // Converte a mensagem para maiúsculas
    String response = message.toUpperCase();
    
    try {
      // Envia confirmação de volta ao remetente
      session.getBasicRemote().sendText("Você disse: " + response);
      
      // Transmite a mensagem original para todos os outros clientes
      broadcast("Cliente diz: " + message, session);
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  // Gerencia desconexões de clientes.
  @OnClose
  public void onClose(Session session) {
    sessions.remove(session);
    int count = clientCount.decrementAndGet();
    System.out.println("Cliente seguro desconectado. Total restante: " + count);
    broadcast("Um cliente saiu do chat. Total online: " + count);
  }

  @OnError
  public void onError(Session session, Throwable throwable) {
    System.err.println("Erro na conexão segura: " + throwable.getMessage());
    sessions.remove(session);
    clientCount.decrementAndGet();
  }

  // Envia uma mensagem para todos os clientes conectados.
  private static void broadcast(String message) {
    synchronized (sessions) {
      for (Session s : sessions) {
        if (s.isOpen()) {
          try {
            s.getBasicRemote().sendText(message);
          } catch (IOException e) {
            e.printStackTrace();
          }
        }
      }
    }
  }

  // Envia uma mensagem para todos os clientes conectados exceto o especificado.
  private static void broadcast(String message, Session excludeSession) {
    synchronized (sessions) {
      for (Session s : sessions) {
        if (s.isOpen() && !s.equals(excludeSession)) {
          try {
            s.getBasicRemote().sendText(message);
          } catch (IOException e) {
            e.printStackTrace();
          }
        }
      }
    }
  }

  public static int getClientCount() {
    return clientCount.get();
  }
}
```

### Cliente WebSocket Seguro

```java
package br.ldamd;

import jakarta.websocket.*;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URI;
import java.security.KeyStore;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManagerFactory;

@ClientEndpoint
public class WssChatClient extends Endpoint {
    private Session session;
    private BufferedReader userInput;

    @OnOpen
    public void onOpen(Session session, EndpointConfig config) {
        this.session = session;
        System.out.println("Conectado ao servidor de chat seguro");
    }

    @OnMessage
    public void onMessage(String message) {
        System.out.println("Servidor diz: " + message);
    }

    @OnClose
    public void onClose() {
        System.out.println("Conexão segura com o servidor encerrada");
    }

    @OnError
    public void onError(Throwable throwable) {
        System.err.println("Erro na conexão segura: " + throwable.getMessage());
    }

    public void sendMessage(String message) {
        try {
            session.getBasicRemote().sendText(message);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        try {

            // Configura o contexto SSL para o cliente
            KeyStore keyStore = KeyStore.getInstance("JKS");
            keyStore.load(new FileInputStream(
                    "d:\\OneDrive - sga.pucminas.br\\git-code\\disciplinas\\ldamd\\aulas\\Java Sockets\\chat-websocket-wss\\keystore.jks"),
                    "shulambs".toCharArray());

            TrustManagerFactory tmf = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
            tmf.init(keyStore);
            SSLContext sslContext = SSLContext.getInstance("TLS");
            sslContext.init(null, tmf.getTrustManagers(), null);


                        
            // Configura as propriedades do cliente para a conexão segura
            ClientEndpointConfig.Builder configBuilder = ClientEndpointConfig.Builder.create();
            ClientEndpointConfig config = configBuilder.build();
            
            config.getUserProperties().put("org.apache.tomcat.websocket.SSL_CONTEXT", sslContext);

            WssChatClient client = new WssChatClient();
            
            WebSocketContainer container = ContainerProvider.getWebSocketContainer();
            container.connectToServer(client, config, URI.create("wss://localhost:8443/securechat"));

            client.userInput = new BufferedReader(new InputStreamReader(System.in));
            System.out.println("Digite suas mensagens (ou 'sair' para desconectar):");

            String input;
            while ((input = client.userInput.readLine()) != null) {
                if ("sair".equalsIgnoreCase(input)) {
                    client.session.close();
                    break;
                }
                client.sendMessage(input);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```
