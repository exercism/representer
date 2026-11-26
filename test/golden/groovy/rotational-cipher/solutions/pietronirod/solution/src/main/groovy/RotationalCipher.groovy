class RotationalCipher {
    private static final char lowerCaseBase = 'a'
    private static final char upperCaseBase = 'A'
    private int key

    RotationalCipher(int key) {
        this.key = key
    }

    String rotate(String cipherText) {
        cipherText.toCharArray().collect {
            it.isLetter()?
                    translate(it)
                    :it
        }.join()
    }

    private char translate(char letter) {
        int base = letter.isLowerCase()? lowerCaseBase: upperCaseBase
        (letter - base + key) % 26 + base
    }
}
