class Isogram {
    static boolean isIsogram(String phrase) {

        def sanitized = phrase.toUpperCase()
            .replaceAll(~/[\s-]/, "")
            .collect { c -> c}

        sanitized.size() == sanitized.unique().size()
    }
}