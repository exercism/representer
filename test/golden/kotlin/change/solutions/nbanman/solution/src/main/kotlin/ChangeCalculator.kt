import java.lang.IllegalArgumentException

class ChangeCalculator(val coinDenominations: List<Int>) {

    /*
     * Front-end, with error checking and sorting the list of coins used. The grunt work is done through the recursive
     * calculate() function.
     */
    fun computeMostEfficientChange(value: Int): List<Int> {
        require(value >= 0) { "Negative totals are not allowed." }

        if (value == 0) return emptyList()

        val coins = calculate(value)

        if (coins.size == 0)
            throw IllegalArgumentException("The total $value cannot be represented in the given currency.")

        else return coins.sorted()
    }

    /*
     * Recursive function tries all denominations from largest to smallest. Returns empty list if it (along with its
     * children) fails to find a solution; otherwise it will return the most efficient solution it finds.
     */
    fun calculate(remainingValue: Int): List<Int> {

        var bestSolution: List<Int> = emptyList()
        var potentialSolution: List<Int>

        // Loops through all coin denominations, from largest to smallest. If it can be determined that the most
        // efficientsolution at this level has been found, it will return that result. Otherwise, it will try each
        // denomination and save a copy of the most efficient solution found as the "bestSolution."
        for (coin in coinDenominations.reversed()) {

            // If the coin is exactly the remaining value, it is the best solution.
            if (remainingValue == coin) return List(1) { coin }

            // If a solution has already been found at this level and it uses no more coins than the current
            // denomination could possibly accomplish it with, it is the best solution.
            if (bestSolution.size != 0 && coin * bestSolution.size <= remainingValue) return bestSolution

            // If the coin is smaller than the remaining value, recursively call the function on the remaining amount
            // as if the coin were used. If an empty list is returned, the attempt failed. If a list with elements is
            // returned, it succeeded. It may not be the most efficient solution, however. Add the results of the
            // recursive function (plus the trial coin) to the bestSolution variable, but carry on running the loop
            // through smaller denominations.
            if (remainingValue > coin) {
                potentialSolution = calculate(remainingValue - coin)
                if (potentialSolution.size > 0
                    && (bestSolution.size == 0 || bestSolution.size > potentialSolution.size))
                    bestSolution = potentialSolution + List(1) { coin }
            }
        }

        // After running through all denominations, this will either return an empty list (indicating failure), or
        // the most efficient list found at this level.
        return bestSolution
    }
}
