object Series {
    fun slices(n: Int, digit: String): List<List<Int>> {

        require(digit.isNotBlank() && n <= digit.length && n > 0)

        return digit.windowed(n, 1, false) { it.map { c -> c - '0' } }
    }
}