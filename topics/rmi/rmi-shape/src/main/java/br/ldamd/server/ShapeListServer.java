package br.ldamd.server;


import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;

import br.ldamd.remote.ShapeList;
import br.ldamd.remote.ShapeListServant;

public class ShapeListServer {
	public static void main(String args[]) {
		
		System.setProperty("java.rmi.server.hostname", "localhost");
		System.setProperty("java.rmi.server.useLocalHostname","true");
		System.setProperty("java.security.policy","rmi.policy");
		
		try {
			ShapeList aShapeList = new ShapeListServant();
			ShapeList stub = (ShapeList) UnicastRemoteObject.exportObject(aShapeList, 0);
            Registry registry = LocateRegistry.createRegistry(10099);
			registry.rebind("ShapeList", stub);
			System.out.println("Servidor ShapeList pronto...");
		} catch (Exception e) {
			System.err.println("ShapeListServer: m�todo main " + e.getMessage());
			e.printStackTrace();
		}
	}
}
