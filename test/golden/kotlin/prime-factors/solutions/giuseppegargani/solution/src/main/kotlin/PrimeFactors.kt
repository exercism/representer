//sono due diverse funzioni che accettano due tipi diversi di dato
//http://butunclebob.com/ArticleS.UncleBob.ThePrimeFactorsKata
//si divide per il più piccolo numero cioè due e si cerca di dividere di nuovo il resto per i numeri da due in poi
//il fattore cresce sempre e il multiplo pure si riduce

//ogni volta ritorna ricorsivamente ad un certo punto
//SI DEVE METTERE RETURN NEI BLOCCHI WHEN DEI RAMI ITERATTIVI!!
//C'E' UN PROBLEMA DI SCOPE
//COMPANION OBJECT VA DENTRO AD UNA CLASSE
//TAILREC ALTRIMENTI DA' PROBLEMA DI STACKOVERFLOW!!!!
//https://www.programiz.com/kotlin-programming/recursion

object PrimeFactorCalculator {

    fun primeFactors(int: Int): List<Int> {

        var finale = mutableListOf<Int>()
        var fattore = 2

        fun dividi(int: Int): List<Int> {
            when {
                int == 1 -> return finale   //se il numero è 1
                fattore >= int -> {
                    finale.add(int)
                    return finale
                }
                int % fattore == 0 -> {
                    finale.add(fattore)
                    return dividi(int = int / fattore)
                }
                else -> {
                    fattore++
                    return dividi(int = int)
                }
            }
        }
        dividi(int)
        return finale
    }

    fun primeFactors(long: Long): List<Long> {
        var finale = mutableListOf<Long>()
        var fattore = 2L

        //SI DEVE USARE TAILREC!!!!
        tailrec fun dividi(lungo: Long): List<Long> {
            when {
                lungo == 1.toLong() -> return finale   //se il numero è 1
                fattore >= lungo -> {
                    finale.add(lungo)
                    return finale
                }
                lungo%fattore == 0L -> {
                    finale.add(fattore)
                    return dividi(lungo/fattore)
                }
                else -> {
                    fattore++
                    return dividi(lungo)
                }
            }
        }
        dividi(long)
        return finale
    }
}

