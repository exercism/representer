class ChangeCalculator(moneyKinds: List<Int>) {
    private val coins = moneyKinds.sorted()

    fun computeMostEfficientChange(total: Int): List<Int> {
        require(total >= 0) { "Negative totals are not allowed." }

        if (total == 0) return listOf()

        val minComboN = total / coins.last()
        val maxComboN = total / coins.first()
        val answer = (minComboN..maxComboN).asSequence()
            .flatMap { KCombinations(it, coins).sequence() }
            .filter { it.sum() == total }
            .firstOrNull()

        require(answer != null) {
            "The total $total cannot be represented in the given currency."
        }

        return answer
    }
}

/*
 * Adapted from https://rosettacode.org/wiki/Combinations_with_repetitions
 */
class KCombinations<T>(
    private val m: Int,
    private val items: List<T>
) {

    private val combination = IntArray(m)
    private val n = items.count()

    fun sequence(k: Int = 0): Sequence<List<T>> = when {
        k >= m -> sequenceOf((0 until m).map(combination::get).map(items::get))
        else -> (0 until n).asSequence()
            .filter { k == 0 || it >= combination[k - 1] }
            .flatMap {
                combination[k] = it
                sequence(k + 1)
            }
    }
}