class ChangeCalculator(private val coins: List<Int>) {

    /**
     * Solved by dynamic programming
     */
    fun computeMostEfficientChange(grandTotal: Int): List<Int> {
        if (grandTotal < 0) {
            throw IllegalArgumentException("Negative totals are not allowed.")
        }

        /**
         * coinsUsed will hold the optimal solution for any value up to the index in the list
         * The Pair is: (n coins used, last coin used)
         * We start it off with (0,0) so that the index in the list is also the value we can meke
         */
        val coinsUsed: MutableList<Pair<Int?, MutableList<Int>>> = mutableListOf(Pair(0, mutableListOf(0)))

        for (v in 1..grandTotal) {
            if (v in coins) { // in this case we can solve for v with one coin of value
                coinsUsed.add(Pair(1, mutableListOf(v)))
            } else {
                val nextOptions = coins.filter { it < v }.map { mapIt ->
                    coinsUsed[v - mapIt].first?.let {
                        Pair(it + 1, (coinsUsed[v - mapIt].second + mapIt) as MutableList<Int>)
                    } ?: Pair(null, mutableListOf(0))
                }

                val best = nextOptions.filter { it.first != null }.minByOrNull { it.first!! }
                best?.let { coinsUsed.add(it) } ?: coinsUsed.add(Pair(null, mutableListOf(0)))
            }
        }

        if (coinsUsed.size != 1 && coinsUsed.last().first == null) {
            throw IllegalArgumentException("The total ${grandTotal} cannot be represented in the given currency.")
        }
        return if (coinsUsed.size == 1 || coinsUsed.last().first == null) {
            listOf()
        } else {
            coinsUsed.last().second.sorted()
        }
    }
}
