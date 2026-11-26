object PrimeFactorCalculator {

    fun primeFactors(int: Int): List<Int> {
        require(int > 0) { "Input must be a positive integer" }
        return primeFactors(int.toLong()).map { it.toInt() }
    }

    fun primeFactors(long: Long): List<Long> {
        require(long > 0) { "Input must be a positive integer" }
        val factors = mutableListOf<Long>()
        var n = long
        var divisor = 2L

        while (n > 1) {
            if (n % divisor == 0L) {
                factors.add(divisor)
                n /= divisor
            } else {
                divisor++
                if (divisor * divisor > n) {
                    if (n > 1) factors.add(n)
                    break
                }
            }
        }

        return factors
    }
}