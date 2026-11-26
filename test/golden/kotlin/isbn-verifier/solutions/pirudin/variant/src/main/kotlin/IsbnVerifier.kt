class IsbnVerifier {

    fun isValid(number: String): Boolean {
        val input = number.replace("-", "")
        if (input.length != 10) {
            return false
        }

        var sum: Int = 0
        var i = 0
        var j = 10

        while (i < input.length) {
            var value: Int = 0
            var character: Char = input[i]
            if (i == input.length - 1) {
                if (character.isDigit()) {
                    value = character.digitToInt()
                } else if (character.isLetter() && character == 'X') {
                    value = 11
                } else {
                    return false
                }
            } else {
                if (character.isDigit()) {
                    value = character.digitToInt()
                }
                if (character.isLetter()) {
                    return false
                }
            }

            sum += j * value

            j -= 1
            i += 1
        }
        return sum % 11 == 0
    }
}
