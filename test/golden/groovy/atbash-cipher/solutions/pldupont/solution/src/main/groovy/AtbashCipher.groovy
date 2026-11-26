class AtbashCipher {

    static final def CIPHER_MAP = ('a'..'z').collectEntries { [(it as char): (char) (('z' as char) - (it as char) + ('a' as char))]}

    static String encode(String phrase) {
        phrase.toLowerCase().chars
                .findAll{Character.isLetterOrDigit(it)}
                .collect {applyCipher(it)}
                .collate( 5 )*.join()
                .join(" ")
    }

    static def applyCipher(char c) {
        CIPHER_MAP[c] ?:c
    }

    static String decode(phrase) {
        phrase.toLowerCase().chars
                .findAll{Character.isLetterOrDigit(it)}
                .collect {applyCipher(it)}
                .join()
    }
}