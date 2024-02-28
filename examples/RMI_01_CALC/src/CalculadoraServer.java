import java.rmi.Naming;

public class CalculadoraServer {

	public CalculadoraServer() {
		try {
			Calculadora c = new CalculadoraServant();
			Naming.rebind("rmi://localhost/CalculadoraService", c);
		} catch (Exception e) {
			System.out.println(e);
		}
	}

	public static void main(String args[]) {
		new CalculadoraServer();
		System.out.println("Servidor Calculadora em execução.");
	}
}
