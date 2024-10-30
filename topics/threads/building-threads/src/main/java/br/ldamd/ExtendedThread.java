package br.ldamd;

public class ExtendedThread extends Thread {
	public void run() {
		for(int i=0; i<100; i++) {
			System.out.println("Usando herança");
		}
	}
}