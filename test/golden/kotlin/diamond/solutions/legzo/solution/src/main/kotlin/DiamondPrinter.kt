class DiamondPrinter {
    fun printToList(character: Char): List<String> {
        val charactersRange = 'A'..character
        val lineWidth = 2 * charactersRange.count() - 1
        
        val topLines = charactersRange.mapIndexed { index, char ->
            Line(char, index, lineWidth).asString
        }

        return topLines + topLines.dropLast(1).reversed()
    }

    data class Line(
        val character: Char,
        val index: Int,
        val lineWidth: Int
    ) {
        private fun Int.spaces() = " ".repeat(this)

        private val innerPadding = 2 * index - 1

        private val outerPadding =
            if (character == 'A')
                (lineWidth - 1) / 2
            else
                (lineWidth - 2 - innerPadding) / 2

        val asString =
            if (character == 'A')
                outerPadding.spaces() + character + outerPadding.spaces()
            else
                outerPadding.spaces() + character + innerPadding.spaces() + character + outerPadding.spaces()
    }

}
