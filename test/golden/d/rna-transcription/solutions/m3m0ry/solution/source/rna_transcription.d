module rna_transcription;

import std.algorithm;
import std.array;
import std.conv;

string toRna(string rna)
{
    dchar rnaize(dchar r){
        final switch(r){
            case 'C': return 'G';
            case 'G': return 'C';
            case 'T': return 'A';
            case 'A': return 'U';
        }
    }
    return rna.map!(a => rnaize(a)).to!string;
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
    }

}
