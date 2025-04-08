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