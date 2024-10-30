package br.ldamd.client;

import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

import br.ldamd.engine.Compute;

import java.math.BigDecimal;

public class ComputePi {
    public static void main(String args[]) {
        try {
            String name = "Compute";
            Registry registry = LocateRegistry.getRegistry("localhost",10099);
            Compute comp = (Compute) registry.lookup(name);
            Pi task = new Pi(100000);
            BigDecimal pi = comp.executeTask(task);
            System.out.println(pi);
        } catch (Exception e) {
            System.err.println("ComputePi exception:");
            e.printStackTrace();
        }
    }    
}
