object WordCount {
    fun phrase(phrase: String): Map<String, Int> {
        return phrase.replace(Regex("[,!:?\n&@\$%^.]"), " ")
            .replace(Regex("\\s+"), " ")
            .replace(Regex("'(\\w+)'")) {
                val wordInQuotes = it.groups[2]?.value ?: ""
                wordInQuotes
            }
            .trim()
            .split(" ")
            .map { it.lowercase() }
            .groupBy { it }
            .mapValues { it.value.size }
    }
}