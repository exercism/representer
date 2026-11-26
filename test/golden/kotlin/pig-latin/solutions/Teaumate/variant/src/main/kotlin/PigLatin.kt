object PigLatin {

    fun translate(phrase: String): String {
        fun translateWord(phrase: String): String {
            var regex = "^(yt|[aeiou]|xr)".toRegex()
            if (regex.find(phrase) != null) return phrase + "ay"

            regex = "^(ch|qu|thr|rh|th|sch|squ|[bcdfghjklmnpqrstvwxyz])".toRegex()
            if (regex.find(phrase) != null) {
                val match = regex.find(phrase)
                return phrase.replace(regex, "") + match?.value + "ay"
            }
            return "ok"
        }
        val wordList = phrase.split(" ")
        var ret = ""
        for ((index, word) in wordList.withIndex() ) {
            if (index == 1) ret += translateWord(word) else ret += " " + translateWord(word)
        }
        return ret
    }
}
