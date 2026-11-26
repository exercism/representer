object Pangram {
    fun isPangram(str: String): Boolean =
        ('a'..'z').all {
            str.contains(it, ignoreCase = true)
        }
}