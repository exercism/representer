class Acronym {

    static String abbreviate(String phrase) {
        phrase.split("[ _-]").findAll{ it }.collect{it.charAt(0).toUpperCase()}.join()
    }

}