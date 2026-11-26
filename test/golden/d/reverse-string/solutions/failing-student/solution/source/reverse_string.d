module reverse_string;

string
reverseString (in string s) {
	import std.uni: byGrapheme, compose;
	import std.algorithm: map, fold;
	import std.range: retro;
	import std.array: array, join;
	import std.conv: to;

	return s.byGrapheme
		.array.retro
		.map!(a => a.fold!compose)
		.array /* It returns a dchar[] */
		.to!string;
}

unittest
{
    immutable int allTestsEnabled = 1;

    // An empty string
    assert(reverseString("") == "");

    static if (allTestsEnabled)
    {
        // A word
        assert(reverseString("robot") == "tobor");

        // A capitalized word
        assert(reverseString("Ramen") == "nemaR");

        // A sentence with punctuation
        assert(reverseString("I'm hungry!") == "!yrgnuh m'I");

        // A palindrome
        assert(reverseString("racecar") == "racecar");

        // An even-sized word
        assert(reverseString("drawer") == "reward");

	// Some unicode characters 
	assert(reverseString("M-a călcat o mașină") == "ănișam o taclăc a-M");
    }
}
