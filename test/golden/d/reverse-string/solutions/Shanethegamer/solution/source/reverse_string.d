module reverse_string;

import std.algorithm.mutation : reverse;

string reverseString(const(string) s) pure @safe
{
    auto s_copy = dup(s);
    reverse(s_copy);
    return s_copy;
}

unittest
{
    immutable int allTestsEnabled = 0;

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
