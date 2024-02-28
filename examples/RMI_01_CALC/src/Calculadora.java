public interface Calculadora extends java.rmi.Remote {

	public double somar(double a, double b) throws java.rmi.RemoteException;

	public double subtrair(double a, double b) throws java.rmi.RemoteException;

	public double multiplicar(double a, double b) throws java.rmi.RemoteException;

	public double dividir(double a, double b) throws java.rmi.RemoteException;
}
