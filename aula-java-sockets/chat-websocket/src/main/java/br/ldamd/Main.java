package br.ldamd;

import org.glassfish.tyrus.server.Server;

public class Main {
    public static void main(String[] args) {
        Server server = new Server("localhost", 8080, "/", null, WebSocketChatServer.class);

        try {
            server.start();
            System.out.println("Servidor de chat WebSocket iniciado. Pressione qualquer tecla para parar...");
            System.in.read();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            server.stop();
        }
    }
}