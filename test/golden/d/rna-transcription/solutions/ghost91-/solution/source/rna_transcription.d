module rna_transcription;

auto nucleotideComplement(dchar nucleotide) {
    switch (nucleotide) {
    case 'C':
        return 'G';
    case 'G':
        return 'C';
    case 'T':
        return 'A';
    case 'A':
        return 'U';
    default:
        throw new Exception("Illegal nucleotide");
    }
}

auto dnaComplement(string dna) {
    import std.algorithm.iteration : map;
    import std.array : array;

    return dna.map!(nucleotide => nucleotide.nucleotideComplement)
        .array;
}

unittest {
    import std.exception : assertThrown;

    const int allTestsEnabled = 0;

    assert(dnaComplement("C") == "G");
    assert(dnaComplement("G") == "C");
    assert(dnaComplement("T") == "A");
    assert(dnaComplement("A") == "U");

    assert(dnaComplement("ACGTGGTCTTAA") == "UGCACCAGAAUU");

    assertThrown(dnaComplement("U"));
    assertThrown(dnaComplement("XXX"));
    assertThrown(dnaComplement("ACGTXXXCTTAA"));
    static if (allTestsEnabled) {
    }

}