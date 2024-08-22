package br.ldamd;

import java.util.ArrayList;
import java.util.Collection;


public class Main {
	public static void main(String[] args) {
		//armazena o tempo inicial
        long ti = System.currentTimeMillis();

        //armazena a quantidade de nucleos de processamento disponiveis
        int numThreads = Runtime.getRuntime().availableProcessors();
        System.out.println(numThreads);

        //intervalo de busca predeterminado
        int valorInicial = 1;
        int valorFinal = 100000;

        //lista para armazenar os numeros primos encontrados pelas threads
        Collection<Long> primos = new ArrayList<>();

        //lista de threads
        Collection<CalculaPrimos> threads = new ArrayList<>();

        int trabalho = valorFinal / valorInicial;

        //cria threads conforme a quantidade de nucleos
        for (int i = 1; i <= numThreads; i++) {
            //trab é a quantidade de valores que cada thread irá calcular
            int trab = Math.round(trabalho / numThreads);

            //calcula o valor inicial e final do intervalo de cada thread
            int fim = trab * i;
            int ini = (fim - trab) + 1;

//cria a thread com a classe CalculaPrimos que estende da classe Thread
            CalculaPrimos thread = new CalculaPrimos(ini, fim, primos);
            //define um nome para a thread
            thread.setName("Thread "+i);
            threads.add(thread);
        }

        //percorre as threads criadas iniciando-as
        for (CalculaPrimos cp : threads) {
            cp.start();
        }

        //aguarda todas as threads finalizarem o processamento
        for (CalculaPrimos cp : threads) {
            try {
                cp.join();
            } catch (InterruptedException ex) {
                ex.printStackTrace();
            }
        }

        //imprime os numeros primos encontrados por todas as threads
        for (Long primo : primos) {
            System.out.println(primo);
        }

        //calcula e imprime o tempo total gasto
        System.out.println("tempo: " + (System.currentTimeMillis() - ti));
    }
}