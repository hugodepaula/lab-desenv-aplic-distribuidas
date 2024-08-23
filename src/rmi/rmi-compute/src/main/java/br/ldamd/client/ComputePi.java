package br.ldamd.client;

import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

import br.ldamd.engine.Compute;

import java.math.BigDecimal;

public class ComputePi {
    public static void main(String args[]) {
//        if (System.getSecurityManager() == null) {
//            System.setSecurityManager(new SecurityManager());
//        }
        try {
            String name = "Compute";
            Registry registry = LocateRegistry.getRegistry(args[0]);
            Compute comp = (Compute) registry.lookup(name);
            Pi task = new Pi(Integer.parseInt(args[1]));
            BigDecimal pi = comp.executeTask(task);
            System.out.println(pi);
        } catch (Exception e) {
            System.err.println("ComputePi exception:");
            e.printStackTrace();
        }
    }    
}
