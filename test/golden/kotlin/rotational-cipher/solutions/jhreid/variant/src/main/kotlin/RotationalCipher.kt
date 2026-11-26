class RotationalCipher
    (var key: Int) {

    fun encode(text: String): String {
        return text.toCharArray().map{ c ->
            when {
                c.code in 65..90 -> {
                    Char(if (c.code + key > 90) c.code + key - 27 else c.code + key)
                }
                c.code in 97..122 -> {
                    Char(if (c.code + key > 122) c.code + key - 26 else c.code + key)
                }
                else -> c
            }
        }.joinToString("")
    }
}
