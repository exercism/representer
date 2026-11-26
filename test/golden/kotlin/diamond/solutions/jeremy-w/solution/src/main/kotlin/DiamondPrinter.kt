class DiamondPrinter {
    fun printToList(c: Char): List<String> {
        require(c in 'A' .. 'Z') { "Character must be in A-Z, but got: $c" }

        val quadWidth = c - 'A'
        val upperLeftQuad = ('A' .. c)
            .zip(quadWidth downTo 0)
            .map { (c, i) -> " ".repeat(i) + c + " ".repeat(quadWidth - i) }

        // Mirror each line in the quadrant horizontally around its last character.
        val upperHalf = upperLeftQuad.map { it + it.reversed().drop(1) }

        // Mirror the whole upper half vertically around the last row.
        val diamond = upperHalf + upperHalf.reversed().drop(1)
        return diamond
    }
}