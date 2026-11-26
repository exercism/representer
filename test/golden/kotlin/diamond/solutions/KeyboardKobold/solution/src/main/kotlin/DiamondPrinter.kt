class DiamondPrinter {

    fun printToList(symbol: Char): List<String> {
        if (symbol == 'A') return listOf("A")

        val symbolRange = 'A'.rangeTo(symbol).toList()
        val width = (symbolRange.size * 2) - 1

        val output: MutableList<String> = mutableListOf()

        var positionFront = (width/2)
        var positionBack = (width/2)

        for (currentSymbol in symbolRange) {
            var line = ""
            for (i in 0 until width) {
                if (i == positionFront || i == positionBack) line += currentSymbol
                else line += " "
            }
            positionFront -= 1
            positionBack += 1
            output.add(line)
        }

        output.addAll(output.subList(0, output.size-1).reversed())
        return output
    }

}