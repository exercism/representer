class ScrabbleScore {
    static Map scores = splitKeysFunctional(
            "AEIOULNRST": 1,
            "DG" : 2,
            "BCMP": 3,
            "FHVWY": 4,
            "K": 5,
            "JX": 8,
            "QZ": 10,
    )

    static Map splitKeysImperative(Map m) {
        def result = [:]
        m.each { letters, score ->
            letters.each { letter ->
                result[letter] = score
            }
        }
        result
    }

    static Map splitKeysFunctional(Map m) {
        m.collectMany {
            letters, score -> letters.collect{
                letter -> [(letter): score]
            }
        }.collectEntries()
    }

    static scoreWord(String word) {
        word.toUpperCase().toList().collect{scores[it]}.sum(0)
    }

}
