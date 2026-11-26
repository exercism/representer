class RotationalCipher {
    private int key

    RotationalCipher(int key) {
        this.key = key
    }

    String rotate(String cipherText) {
        def shifted = (0..25).collect{('a'..'z').toList()[(it-key) % 26]}

        def shiftedMap = (0..25).collectEntries{[('a'..'z').toList()[it], shifted[it]]} + (0..25).collectEntries{[('A'..'Z').toList()[it],shifted[it].toUpperCase()]}

        cipherText.collect{shiftedMap.containsKey(it) ? shiftedMap[it] : it}.join()
    }
}