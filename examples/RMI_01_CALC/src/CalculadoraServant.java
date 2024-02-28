public class CalculadoraServant extends java.rmi.server.UnicastRemoteObject implements Calculadora {

	private static final long serialVersionUID = 1L;
	private int cont = 0;

	public CalculadoraServant() throws java.rmi.RemoteException {
		super();
	}

	public double somar(double a, double b) throws java.rmi.RemoteException {
		return a + b + cont++;
	}

	public double subtrair(double a, double b) throws java.rmi.RemoteException {
		return a - b + cont++;
	}

	public double multiplicar(double a, double b) throws java.rmi.RemoteException {
		return a * b + cont++;
	}

	public double dividir(double a, double b) throws java.rmi.RemoteException {
		return a / b + cont++;
	}
}
