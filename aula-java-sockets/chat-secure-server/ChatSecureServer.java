
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

        // Incrementa o contador de clientes conectados
        // synchronized gera um lock (trava) para a classe ChatServer,
        // de modo que ela não poderá ser acessada concorrentemente
        // Isto faz sentido porque os atributos são estáticos
        synchronized (ChatSecureServer.class) {
          clientCount++;
        }

        System.out.println("Novo cliente conectado: " + clientSocket.getRemoteSocketAddress());
        // Processa o cliente em uma nova thread
        // Se houver threads ociosas ele reaproveita a thread,
        // caso contrário ele cria uma nova
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