package br.ldamd;

public class RunnableThread implements Runnable {
	public void run() {
		for(int i=0; i<100; i++){
			System.out.println("Usando runnable");
		}
	}
}