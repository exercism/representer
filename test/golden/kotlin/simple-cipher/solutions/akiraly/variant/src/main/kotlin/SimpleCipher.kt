data class Cipher(val key: String = (0 until 100).map { range.random() }.joinToString("")) {
    companion object {
        private val range = ('a'..'z')
        private val length = range.count()
    }

    init {
        require(key.isNotEmpty() && key.all { it.isLowerCase() })
    }

    fun encode(s: String): String =
        s.zip(adaptKey(s))
            .map { (c, k) -> 'a' + (c - 'a' + (k - 'a')) % length }
            .joinToString("")

    fun decode(s: String): String =
        s.zip(adaptKey(s))
            .map { (c, k) -> 'a' + (c - 'a' - (k - 'a') + length) % length }
            .joinToString("")

    private fun adaptKey(s: String) =
        if (key.length < s.length) key.repeat(s.length / key.length + 2) else key
}
