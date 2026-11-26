class DiamondPrinter {
    fun printToList(letter: Char): List<String> {
        var controlChar = 'A'
        var ascending = true
        val resultList = mutableListOf<String>()
        val initialDifference = letter - controlChar
        val iterations = (initialDifference * 2) + 1

        for (iteration in 0 until iterations) {
            val startDifference = letter - controlChar
            val endDifference = initialDifference - startDifference - 1

            resultList.add(
                    buildString {
                        when (controlChar) {
                            'A' -> {
                                append("".padStart(startDifference))
                                append(controlChar)
                                append("".padEnd(startDifference))
                            }
                            else -> {
                                append("".padStart(startDifference))
                                append(controlChar)
                                append("".padEnd(endDifference))
                                append(' ')
                                append("".padStart(endDifference))
                                append(controlChar)
                                append("".padEnd(startDifference))
                            }
                        }
                    }
            )


            if (ascending) {
                controlChar++
                ascending = controlChar != letter
            } else controlChar--
        }

        return resultList
    }
}
