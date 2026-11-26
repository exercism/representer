object Luhn {

    private fun checkDouble(n: Int): Int = if (n > 9) n - 9 else n

    fun isValid(candidate: String): Boolean {
        val trimmed = candidate.trim()
        return if (trimmed.length < 2 || trimmed.filter { it.isDigit() || it == ' ' }.length != trimmed.length) {
            false
        } else {
            trimmed
                .filter { it.isDigit() }
                .map { it.toString().toInt() }
                .reversed()
                .zip(1..trimmed.length)
                .sumBy {
                    when (it.second % 2) {
                        0 -> checkDouble(2 * it.first)
                        else -> it.first
                    }
                } % 10 == 1
        }
    }

}
