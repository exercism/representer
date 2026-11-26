object RunLengthEncoding {
    fun encode(input: String): String {
        var result: String = ""
        var currentLetter: Char? = null
        var currentCounter: Int = 0
        for (letter in input) {
            if (currentLetter != letter) {
                result += getEncodedValue(currentCounter, currentLetter)
                currentLetter = letter
                currentCounter = 0
            }
            currentCounter++
        }
        result += getEncodedValue(currentCounter, currentLetter)

        return result
    }

    private fun getEncodedValue(counter: Int, letter: Char?): String {
        if (letter == null) {
            return ""
        }

        return when (counter) {
            0 -> ""
            1 -> letter.toString()
            else -> counter.toString() + letter
        }
    }

    fun decode(input: String): String {
        var currentCounter: String = ""
        var result: String = ""
        for (symbol in input) {
            if (symbol in '0'..'9') {
                currentCounter += symbol
            } else {
                result += symbol.toString().repeat(
                        if (currentCounter == "") 2 else currentCounter.toInt()
                )
                currentCounter = ""
            }
        }

        return result
    }
}
