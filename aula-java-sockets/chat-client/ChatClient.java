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