fun reverse(input: String): String {
    val lengthOfString = input.length
    var outputString = ""
    return if (lengthOfString == 0) {
        input
    } else {
        for (i in lengthOfString - 2 downTo 0) {
            val character = input[i]
            if (outputString.isEmpty()) {
                outputString = character.toString()
            } else {
                outputString += character.toString()
            }
        }
        outputString
    }
}

