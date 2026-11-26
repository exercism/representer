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

auto distance(in string a1, in string a2) {
	import std.algorithm : count;
	import std.range : zip, StoppingPolicy;

	return StoppingPolicy.requireSameLength.zip(a1, a2)
		.count!(a => a[0] != a[1]);
}