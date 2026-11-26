object Luhn {
    fun isValid(input: String): Boolean {

        val noSpace = input.filter { c -> c != ' ' }
        val numbers = input.filter { c -> c in '0'..'9' }
        if (noSpace != numbers) return false

        if (noSpace.length <= 2) return false

        val intArray = noSpace.reversed().map { (it - '0') }.mapIndexed { index, i -> if (index % 2 == 1) 2 * i else i }
        val cappedInts = intArray.map { it -> if (it > 9) it - 9 else it }
        val checkSum = cappedInts.sum()
        return checkSum % 10 == 0
    }

    fun isValid2(input: String): Boolean {
        val reversedTrimmedString = input.replace(" ", "").reversed()
        if (reversedTrimmedString.length < 2 || reversedTrimmedString.contains("[^0-9]".toRegex())) return false
        var sum = reversedTrimmedString.mapIndexed { index, c -> if (index % 2 == 1) 2 * c.toString().toInt() else c.toString().toInt() }
                .map { if (it > 9) it - 9 else it }.sum()
        return sum % 10 == 0
    }
}