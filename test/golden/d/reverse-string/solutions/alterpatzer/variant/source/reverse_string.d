module reverse_string;

import std.algorithm.mutation : reverse;

pure string reverseString(immutable string value)
{
    return value.dup.reverse;
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
    }
}
