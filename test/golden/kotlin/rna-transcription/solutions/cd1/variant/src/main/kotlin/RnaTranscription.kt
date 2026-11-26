fun transcribeToRna(dna: String): String {
    return dna.filter {
        when (it) {
            'G' -> 'C'
            'C' -> 'G'
            'T' -> 'A'
            'A' -> 'U'
            else -> {
                'X'
            }
        }
    }.joinToString("")
}