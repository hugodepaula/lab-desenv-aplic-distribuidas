package br.ldamd;

import org.glassfish.tyrus.server.Server;
import org.glassfish.grizzly.ssl.SSLEngineConfigurator;

import javax.net.ssl.SSLContext;
import java.io.FileInputStream;
import java.security.KeyStore;
import java.util.HashMap;
import java.util.Map;

public class Main {
    public static void main(String[] args) {

        try {
            // Load the keystore
            KeyStore keyStore = KeyStore.getInstance("JKS");
            keyStore.load(new FileInputStream("d:\\OneDrive - sga.pucminas.br\\git-code\\disciplinas\\ldamd\\aulas\\Java Sockets\\chat-websocket-wss\\keystore.jks"), "shulambs".toCharArray());

            // Initialize the SSLContext
            SSLContext sslContext = SSLContext.getInstance("TLS");
            sslContext.init(null, null, null);

            // Configure the server
            Map<String, Object> properties = new HashMap<>();
            properties.put("org.glassfish.tyrus.container.grizzly.server.SSLEngineConfigurator",
                    new SSLEngineConfigurator(sslContext, false, false, false));

            Server server = new Server("localhost", 8443, "/securechat", properties, WssChatServer.class);

            server.start();
            System.out.println("WebSocket server started with SSL on wss://localhost:8443/securechat");

            // Keep the server running
            Thread.currentThread().join();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}