
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;

public class ShapeListServer {
	public static void main(String args[]) {
		
		System.setProperty("java.rmi.server.hostname", "localhost");
		System.setProperty("java.rmi.server.useLocalHostname","true");
		System.setProperty("java.security.policy","rmi.policy");
		
		if (System.getSecurityManager() == null) {
			System.setSecurityManager(new SecurityManager());
		}
		try {
			ShapeList aShapeList = new ShapeListServant();
			ShapeList stub = (ShapeList) UnicastRemoteObject.exportObject(aShapeList, 0);
			Registry registry = LocateRegistry.getRegistry();
			registry.rebind("ShapeList", stub);
			System.out.println("Servidor ShapeList pronto...");
		} catch (Exception e) {
			System.err.println("ShapeListServer: método main " + e.getMessage());
			e.printStackTrace();
		}
	}
}
