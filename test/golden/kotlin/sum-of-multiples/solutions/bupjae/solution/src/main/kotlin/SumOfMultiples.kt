object SumOfMultiples {

    fun sum(factors: Set<Int>, limit: Int): Int {
        val f = factors.filterNot { it == 0 }.map { if (it < 0) -it else it }.toSet()
        return (1 until limit).filter { i -> f.any { i % it == 0 }}.sum()
    }
}
