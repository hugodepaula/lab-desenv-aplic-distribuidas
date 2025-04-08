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