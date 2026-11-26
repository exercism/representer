package Pangram

val String.letters: String
    get () = this.toLowerCase().replace(Regex("[\\W_0-9]"), "")

fun isPangram(sentence: String): Boolean = sentence.letters.groupBy{it}.size == 26