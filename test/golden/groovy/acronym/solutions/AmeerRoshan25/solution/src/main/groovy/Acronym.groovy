class Acronym {

    static String abbreviate(String phrase) {
        phrase
            .replaceAll("[^a-zA-Z0-9\\s-]", "")   // Remove all punctuation except hyphen
            .replaceAll("-", " ")                 // Treat hyphens like spaces
            .tokenize()                           // Split into non-empty words
            .collect { it[0].toUpperCase() }      // Take first character, uppercase
            .join("")                             // Join all letters
    }
}
