module rna_transcription;
import std.conv;

string toRna(string dnaCodes)
{
    import std.format : format;
    import std.exception : enforce;

    // define the associative array that maps a dna code to an rna code
    string[string] dna2rnaCodes = ["G" : "C", "C" : "G", "T" : "A", "A" : "U"];

    string rnaCodes;
    foreach (c; dnaCodes)
    {
        enforce(to!string(c) in dna2rnaCodes, format("Bad DNA code sequence: %s", dnaCodes));
        rnaCodes ~= dna2rnaCodes[to!string(c)];
    }
    return rnaCodes;
}

unittest
{
    import std.exception : assertThrown;

    immutable int allTestsEnabled = 1;

    // Empty RNA sequence
    assert(toRna("") == "");

    static if (allTestsEnabled)
    {
        // RNA complement of cytosine is guanine
        assert(toRna("C") == "G");

        // RNA complement of guanine is cytosine
        assert(toRna("G") == "C");

        // RNA complement of thymine is adenine
        assert(toRna("T") == "A");

        // RNA complement of adenine is uracil
        assert(toRna("A") == "U");

        // RNA complement
        assert(toRna("ACGTGGTCTTAA") == "UGCACCAGAAUU");

        assertThrown(toRna("U"));
        assertThrown(toRna("XXX"));
        assertThrown(toRna("ACGTXXXCTTAA"));
    }

}
