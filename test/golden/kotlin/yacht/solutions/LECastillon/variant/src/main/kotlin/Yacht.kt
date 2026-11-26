import YachtCategory.*
object Yacht {
    fun solve(category: YachtCategory, vararg dices: Int): Int {    
        // DECLARING diceCounts
            // Converts array to a map, where keys are the die cast then values are ocurrences
        val diceCounts = dices.groupBy{it}.map {it.key to it.value.size}.toMap()
        // RETURNING SWITCH
        return when (category){
            // ONES .. SIXES
            YachtCategory.ONES   -> dices.filter {it == 1}.sum()  // Sums every instance of 1
            YachtCategory.TWOS   -> dices.filter {it == 2}.sum()  // Sums every instance of 2
            YachtCategory.THREES -> dices.filter {it == 3}.sum()  // Sums every instance of 3
            YachtCategory.FOURS  -> dices.filter {it == 4}.sum()  // Sums every instance of 4
            YachtCategory.FIVES  -> dices.filter {it == 5}.sum()  // Sums every instance of 5
            YachtCategory.SIXES  -> dices.filter {it == 6}.sum()  // Sums every instance of 6
            // FULL_HOUSE
            YachtCategory.FULL_HOUSE -> {
                // if diceCounts values are (2,3)
                // sums all values on dices
                val counts = diceCounts.values.sorted()
                if (counts == listOf(2, 4)) dices.sum() else 0
            }
            // FOUR_OF_A_KIND
                // Filters the diceCounts hashmap for every entry with a value of 4
                // then grabs first key, if null sends 0, else it multiplies key by 4
            YachtCategory.FOUR_OF_A_KIND -> diceCounts.filter { it.value >= 4 }.keys.firstOrNull()?.let { it * 4 } ?: 0
            // LITTLE_STRAIGHT
                // Gets sorted array of dices, if is equal to 12345 return 30 else 0
            YachtCategory.LITTLE_STRAIGHT -> if (dices.sorted() == listOf(1,2,3,4,5)) 30 else 0
            // BIG_STRAIGHT
                // Gets sorted array of dices, if is equal to 23456 return 30 else 0
            YachtCategory.BIG_STRAIGHT -> if (dices.sorted() == listOf(2,3,4,5,6)) 30 else 0
            // CHOICE
                // Returns sum of all die
            YachtCategory.CHOICE -> dices.sum()
            // YACHT
                // If there appears any diceCounts map entry with a value of 5, returns 50 else 0
            YachtCategory.YACHT -> if (diceCounts.values.any { it >= 5 }) 50 else 0
            // DEFAULT
                // Returns 0
            else -> 0
        }
    }
}
