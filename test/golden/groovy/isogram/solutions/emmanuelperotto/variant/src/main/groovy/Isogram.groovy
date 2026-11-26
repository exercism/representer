class Isogram {
    static boolean isIsogram(String phrase) {
        String sanitizedPhrase = phrase.toLowerCase().replaceAll("[^a-z]", "")
        def repeatedWord = sanitizedPhrase.find({sanitizedPhrase.count(it) >= 1 })

        return repeatedWord == null
    }
}