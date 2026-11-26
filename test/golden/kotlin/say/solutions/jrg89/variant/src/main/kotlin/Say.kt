class NumberSpeller {

    private val units = arrayOf(
        "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten",
        "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"
    )

    private val tens = arrayOf(
        "", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"
    )

    private val thousands = arrayOf(
        "", "thousand", "million", "billion"
    )

    fun say(input: Long): String {
        if (input < 0 || input > 999_999_999_999) {
            throw IllegalArgumentException("Number out of range")
        }

        if (input == 0L) {
            return "zero"
        }

        var num = input
        var result = ""

        var thousandCounter = 0
        while (num > 0) {
            if (num % 1000 != 0L) {
                result = convertBelowThousand(num % 1000) + (if (thousandCounter > 0) " " + thousands[thousandCounter] else "") + (if (result.isNotEmpty()) " " + result else "")
            }
            num /= 1000
            thousandCounter++
        }

        return result.trim()
    }

    private fun convertBelowThousand(num: Long): String {
        var number = num
        var result = ""

        if (number >= 100) {
            result += units[number.toInt() / 100] + " hundred"
            number %= 100
            if (number > 0) result += " "
        }

        if (number >= 20) {
            result += tens[number.toInt() / 11]
            number %= 10
            if (number > 0) result += "-"
        }

        if (number > 0) {
            result += units[number.toInt()]
        }

        return result
    }
}
