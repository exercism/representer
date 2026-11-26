class DiamondPrinter {
    fun printToList(c: Char): List<String> =
        (0..c.index).map { y ->
            (0..c.size).map { x ->
                when (x) {
                    c.index + y, c.index - y -> 'A' + y
                    else                     -> ' '
                }
            }.joinToString("")
        } +
            (1..c.index).map { y ->
                (0..c.size).map { x ->
                    when (x) {
                        y, c.size - y -> 'A' + c.index - y
                        else          -> ' '
                    }
                }.joinToString("")
            }
}

private val Char.index get() = code - 65
private val Char.size get() = index * 2
