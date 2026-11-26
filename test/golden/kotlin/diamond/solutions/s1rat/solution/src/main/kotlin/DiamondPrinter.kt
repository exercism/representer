class DiamondPrinter {

    companion object {
        private val alphabet = ('A'..'Z').toList()
    }

    fun printToList(c: Char): List<String> = buildList {
        val charIndex = alphabet.indexOf(c);
        for (i in 0..charIndex) {
            add(
                    when (i) {
                        0 -> " ".repeat(charIndex) + alphabet[i].toString() + " ".repeat(charIndex)
                        else -> " ".repeat(charIndex - i) + alphabet[i].toString() + " ".repeat((2*i) - 1) + alphabet[i].toString() + " ".repeat(charIndex - i)
                    }
            )
        }
        addAll(this.subList(0,charIndex).reversed())
    }


}
