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