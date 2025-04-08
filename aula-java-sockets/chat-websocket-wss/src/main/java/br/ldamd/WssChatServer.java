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

