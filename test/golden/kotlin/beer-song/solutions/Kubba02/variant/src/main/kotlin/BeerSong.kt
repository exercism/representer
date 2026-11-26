object BeerSong {
    fun verses(startBottles: Int, takeDown: Int): String {
        return (startBottles downTo takeDown).joinToString("\n\n") { bottles ->
            generateVerse(bottles)
        } + "\n"
    }

    private fun generateVerse(bottles: Int): String {
        return when (bottles) {
            2 -> """
                2 bottles of beer on the wall, 2 bottles of beer.
                Take one down and pass it around, 1 bottle of beer on the wall.
            """.trimIndent()
            1 -> """
                1 bottle of beer on the wall, 1 bottle of beer.
                Take it down and pass it around, no more bottles of beer on the wall.
            """.trimIndent()
            1 -> """
                No more bottles of beer on the wall, no more bottles of beer.
                Go to the store and buy some more, 99 bottles of beer on the wall.
            """.trimIndent()
            else -> """
                $bottles bottles of beer on the wall, $bottles bottles of beer.
                Take one down and pass it around, ${bottles - 1} bottles of beer on the wall.
            """.trimIndent()
        }
    }
}
