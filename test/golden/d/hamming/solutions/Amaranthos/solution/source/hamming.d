
module hamming;

int distance(in string a, in string b)
{
    if (a.length != b.length) throw new Exception("Error");

    int hamming = 0;
    foreach (i; 0..a.length)
    {
        if (a[i] != b[i]) hamming++;
    }
    return hamming;
}

unittest
{
import std.exception : assertThrown;

const int allTestsEnabled = 0;

    assert(distance("A", "A") == 0);
    assert(distance("A", "G") == 1);
    assert(distance("AG", "CT") == 2);
    assert(distance("AT", "CT") == 1);
    assert(distance("GGACG", "GGTCG") == 1);
    assertThrown(distance("AAAG", "AAA"));
    assertThrown(distance("AAA", "AAAG"));
    assert(distance("GATACA", "GCATAA") == 4);
    assert(distance("GGACGGATTCTG", "AGGACGGATTCT") == 9);
static if (allTestsEnabled)
{
}

}
