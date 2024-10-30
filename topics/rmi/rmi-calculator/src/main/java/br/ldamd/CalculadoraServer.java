package br.ldamd;

import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

public class CalculadoraServer {
	

	public CalculadoraServer() {
		int port = 10098;
		String nome = "CalculadoraService";

		try {
			Calculadora calculadora = new CalculadoraServant();
			Registry registry = LocateRegistry.createRegistry(port);
			registry.rebind(nome, calculadora);
			System.out.println("Servidor Calculadora em execu��o.");
		} catch (Exception e) {
			System.out.println(e);
		}
	}

	public static void main(String args[]) {
		new CalculadoraServer();
	}
}
