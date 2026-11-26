object AffineCipher {

    fun encode(input: String, a: Int, b: Int): String {
        // Check if a is coprime with 26
        require(gcd(a, 26) == 1) { "a and m must be coprime" }
        
        val cleaned = input.lowercase().filter { it.isLetterOrDigit() }
        val result = StringBuilder()
        
        for (char in cleaned) {
            if (char.isDigit()) {
                result.append(char)
            } else {
                val x = char - 'a'
                val encrypted = (a * x + b) mod 26
                result.append('a' + encrypted)
            }
        }
        
        // Group in fives
        return result.toString().chunked(5).joinToString(" ")
    }

    fun decode(input: String, a: Int, b: Int): String {
        require(gcd(a, 26) == 1) { "a and m must be coprime" }
        
        val aInv = modInverse(a, 26)
        val cleaned = input.replace(" ", "")
        val result = StringBuilder()
        
        for (char in cleaned) {
            if (char.isDigit()) {
                result.append(char)
            } else {
                val y = char - 'a'
                var decrypted = (aInv * (y - b)) mod 26
                if (decrypted < 0) decrypted += 26
                result.append('a' + decrypted)
            }
        }
        
        return result.toString()
    }

    private fun modInverse(a: Int, m: Int): Int {
        for (x in 1 until m) {
            if ((a * x) % m == 1) {
                return x
            }
        }
        throw IllegalArgumentException("No modular inverse found")
    }

    private fun gcd(a: Int, b: Int): Int {
        var x = a
        var y = b
        while (y != 0) {
            val temp = y
            y = x % y
            x = temp
        }
        return x
    }
}

// Extension function for mod operation that always returns positive
infix fun Int.mod(mod: Int): Int {
    var result = this % mod
    if (result < 0) result += mod
    return result
}