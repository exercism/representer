module hamming;

unittest
{
import std.exception : assertThrown;

const int allTestsEnabled = 1;

    assert(distance("A", "A") == 0);
static if (allTestsEnabled)
{
    assert(distance("A", "G") == 1);
    assert(distance("AG", "CT") == 2);
    assert(distance("AT", "CT") == 1);
    assert(distance("GGACG", "GGTCG") == 1);
    assertThrown(distance("AAAG", "AAA"));
    assertThrown(distance("AAA", "AAAG"));
    assert(distance("GATACA", "GCATAA") == 4);
    assert(distance("GGACGGATTCTG", "AGGACGGATTCT") == 9);
}

}

uint distance(string dna1, string dna2)
{
	if (dna1.length!=dna2.length) throw new Exception("Strands of different length");

	uint d=0;
	for (size_t i=0; i<dna1.length; i++)
	{
		if (dna1[i]!=dna2[i]) d++;
	}
	return d;
}