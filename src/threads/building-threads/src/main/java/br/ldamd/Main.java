package br.ldamd;

public class Main {

	public static void executeTask() {
		for(int i=0; i<100; i++){
			System.out.println("Usando method reference");
		}
	}

	public static void main(String[] args) {

		new ExtendedThread().start();
		
		new Thread(new RunnableThread()).start();

		new Thread(Main::executeTask).start();

		new Thread(() -> {
			for(int i=0; i<100; i++){
				System.out.println("Usando lambda");
			}
		}).start();

	}
}
