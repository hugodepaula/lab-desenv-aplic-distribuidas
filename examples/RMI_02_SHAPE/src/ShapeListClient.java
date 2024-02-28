import java.rmi.*;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.util.Vector;
import java.awt.Rectangle;
import java.awt.Color;

public class ShapeListClient {
	public static void main(String args[]) {
		String opcao = "ler";
		String forma = "retangulo";
		String preenchido = "nao";

		System.out.println("argslen: " + args.length);
		if (args.length > 0)
			opcao = args[0]; // especifica ler ou escrever
		if (args.length > 1)
			forma = args[1]; // especifica a forma: linha, circulo, quadrado, retangulo.
		if (args.length > 2)
			preenchido = args[2]; // especifica preenchimento.

		System.out.println("opção = " + opcao + " forma = " + forma + " preenchido = " + preenchido);

//		if (System.getSecurityManager() == null) {
//			System.setSecurityManager(new SecurityManager());
//		} else
//			System.out.println("Já possui um Security Manager.");

		ShapeList aShapeList = null;

		try {
			Registry registry = LocateRegistry.getRegistry("localhost");
			aShapeList = (ShapeList) registry.lookup("ShapeList");
			System.out.println("ShapeList Encontrado.");

			Vector<Shape> sList = aShapeList.allShapes(); // Invocação de método remoto
			System.out.println("Retornado o vetor de ShapeList");

			if (opcao.equals("ler")) {
				sList.stream().forEach((s) -> {
					try {
						s.getAllState().print(); // Invocação de método remoto
					} catch (RemoteException e) {
					}
				});
			} else {
				GraphicalObject g = new GraphicalObject(forma, 
						new Rectangle((int) (Math.random()*100), (int) (Math.random()*100), 300, 400), 
						Color.CYAN, Color.MAGENTA, (preenchido.equals("sim") ? true : false));
				System.out.println("Objeto Gráfico criado");

				aShapeList.newShape(g); // Invocação de método remoto
				System.out.println("Armazena forma: " + forma);
			}
		} catch (RemoteException e) {
			System.out.println("Método allShapes: " + e.getMessage());
		} catch (Exception e) {
			System.out.println("Lookup: " + e.getMessage());
		}
	}
}
