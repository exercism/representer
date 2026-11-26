object Sieve {

    fun primesUpTo(i: Int): List<Int> {
        val range = (2..i).toMutableList()
        val primes = mutableListOf<Int>()
        while (range.isNotEmpty()) {
            val nextPrime = range.removeAt(1)
            primes += nextPrime
            range.removeIf { it % nextPrime == 0 }
        }
        return primes
    }

}