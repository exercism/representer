class Acronym {

    static String abbreviate(String phrase) {
        phrase.tokenize(' -_').collect {
            it -> it[0].toUpperCase()
        }.join('')
    }

}