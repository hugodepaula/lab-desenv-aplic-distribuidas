
import java.rmi.Naming;
import java.rmi.RemoteException;
import java.net.MalformedURLException;
import java.rmi.NotBoundException;

public class CalculadoraClient {

	public static void main(String[] args) {
		String servidor = "rmi://localhost/";
		String nome = "CalculadoraService";
		try {
			Calculadora c = (Calculadora) Naming.lookup(servidor + nome);
			System.out.println("Objeto remoto \'"+ nome + "\' encontrado no servidor.");

			int x = 10, y = 5;
			System.out.println(x + " + " + y + " = " + c.somar(x, y));
			System.out.println(x + " - " + y + " = " + c.subtrair(x, y));
			System.out.println(x + " * " + y + " = " + c.multiplicar(x, y));
			System.out.println(x + " / " + y + " = " + c.dividir(x, y));

		} catch (MalformedURLException e) {
			System.out.println("URL \'" + servidor + nome + "\' mal formatada.");
		} catch (RemoteException e) {
			System.out.println("Erro na invocação remota.");
			e.printStackTrace();
		} catch (NotBoundException e) {
			System.out.println("Objeto remoto \'" + nome + "\' não está disponível.");
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
