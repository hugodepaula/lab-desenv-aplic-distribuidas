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