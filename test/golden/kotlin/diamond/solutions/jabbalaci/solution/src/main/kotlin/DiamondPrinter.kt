class DiamondPrinter {

    private val alphabet = ('A'..'Z').joinToString("")

    fun printToList(c: Char): List<String> {

        var ch = c
        var result = mutableListOf<String>()
        var pos = alphabet.indexOf(c)
        val width = (pos + 1) * 2 - 1
        var spacesOut = 0
        var spacesIn = width - 2

        while (true) {
            if (pos == 0) {    // 'A'
                result.add("${" ".repeat(spacesOut)}$ch${" ".repeat(spacesOut)}")
                break
            }
            // else
            result.add("${" ".repeat(spacesOut)}$ch${" ".repeat(spacesIn)}$ch${" ".repeat(spacesOut)}")
            --pos
            ch = alphabet[pos]
            ++spacesOut
            spacesIn -= 2
        }
        if (result.size > 1) {
            val subList = result.subList(1, result.size).reversed()
            result = (subList + result).toMutableList()
        }

        return result
    }

}