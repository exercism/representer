
class DiamondPrinter {
    val charArray: List<Char> = ('A'..'Z').toList()

    private fun doSpace(count: Int): String = " ".repeat(count)

    fun printToList(c: Char): List<String> {
        val ix = charArray.indexOf(c)

        // 1st line
        var ret = listOf(doSpace(ix) + "A" + doSpace(ix))

        // rest of lines
        for (i in 1 until (ix + 1)) {
            ret += doSpace(ix - i) +
                charArray[i] +
                doSpace(i * 2 - 1) +
                charArray[i] +
                doSpace(ix - i)
        }

        // 2nd half of the diamond
        ret += ret.subList(0, ix).reversed()
        return ret
    }
}
