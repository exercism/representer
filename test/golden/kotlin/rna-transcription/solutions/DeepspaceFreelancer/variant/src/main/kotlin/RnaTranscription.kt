val rnaMap = mapOf('G' to 'C',
        'C' to 'G',
        'T' to 'A',
        'A' to 'U')

fun transcribeToRna(dna: String): String {
    return dna.filter{ c -> rnaMap.get(c) }.joinToString("")
}