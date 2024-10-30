package br.ldamd;

import java.util.Collection;

public class CalculaPrimos extends Thread {

    private final int valorInicial;
    private final int valorFinal;
    private final Collection<Long> primos;

    public CalculaPrimos(int valorInicial, int valorFinal, Collection<Long> primos) {
        this.valorInicial = valorInicial;
        this.valorFinal = valorFinal;
        this.primos = primos;
    }

    //tarefa a realizar: procurar numeros primos no intervalo recebido
    @Override
    public void run() {
        for (long ate = valorInicial; ate <= valorFinal; ate++) {
            int primo = 0;
            for (int i = 2; i < ate; i++) {
                if ((ate % i) == 0) {
                    primo++;
                    break;
                }
            }
            if (primo == 0) {
                synchronized (primos) {
                    primos.add(ate);
                }
            }
        }
        // ao final do trabalho printa o nome de quem terminou
        System.out.println(this.getName() + " terminou!");
    }
}