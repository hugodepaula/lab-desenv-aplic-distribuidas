package br.ldamd;


import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.NotBoundException;

public class CalculadoraClient {

	public static void main(String[] args) {
		String servidor = "localhost";
		int port = 10098;
		String nome = "CalculadoraService";
		try {
			Registry registry = LocateRegistry.getRegistry(servidor, port);
			Calculadora c = (Calculadora) registry.lookup(nome);
			System.out.println("Objeto remoto \'"+ nome + "\' encontrado no servidor.");

			int x = 10, y = 5;
			System.out.println(x + " + " + y + " = " + c.somar(x, y));
			System.out.println(x + " - " + y + " = " + c.subtrair(x, y));
			System.out.println(x + " * " + y + " = " + c.multiplicar(x, y));
			System.out.println(x + " / " + y + " = " + c.dividir(x, y));

		} catch (RemoteException e) {
			System.out.println("Erro na invoca��o remota.");
			e.printStackTrace();
		} catch (NotBoundException e) {
			System.out.println("Objeto remoto \'" + nome + "\' n�o est� dispon�vel.");
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
