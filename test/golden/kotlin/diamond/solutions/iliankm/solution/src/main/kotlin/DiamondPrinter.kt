class DiamondPrinter {
    fun printToList(input: Char) =
        (input.index * 2 + 1).let { size ->
            ('A' until input).map { it.toRow(size) } +
                (input downTo 'A').map { it.toRow(size) }
        }
}

private val Char.index: Int
    get() = code - 'A'.code

private fun Char.toRow(size: Int) =
    CharArray(size) { ' ' }.let {
        it[size / 2 - index] = this
        it[size / 2 + index] = this
        String(it)
    }
