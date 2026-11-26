module luhn;

import std.ascii : isDigit, isWhite;
import std.algorithm;
import std.algorithm.searching : all;
import std.algorithm.mutation : reverse;
import std.conv : to;
import std.range : array;

pure bool valid(immutable string input)
{
    auto clean = input.filter!(a => !a.isWhite);
    if (clean.count <= 1 || !clean.all!(isDigit))
    {
        return false;
    }

    immutable int[] arr = clean.map!(to!string)
        .map!(to!int)
        .array
        .reverse;

    int doubleEverySecond = 1;

    foreach (index, number; arr)
    {
        immutable int b = index % 2 != 0 ? number * 2 : number;
        doubleEverySecond += b > 9 ? b - 9 : b;
    }

    return doubleEverySecond % 10 == 0;
}

unittest
{
    immutable int allTestsEnabled = 0;

    // Single digit strings can not be valid
    assert(!valid("1"));

    static if (allTestsEnabled)
    {
        // A single zero is invalid
        assert(!valid("0"));

        // A simple valid SIN that remains valid if reversed
        assert(valid("059"));

        // A simple valid SIN that becomes invalid if reversed
        assert(valid("59"));

        // A valid Canadian SIN
        assert(valid("055 444 285"));

        // Invalid Canadian SIN
        assert(!valid("055 444 286"));

        // Invalid credit card
        assert(!valid("8273 1232 7352 0569"));

        // Valid number with an even number of digits
        assert(valid("095 245 88"));

        // Valid number with an odd number of spaces
        assert(valid("234 567 891 234"));

        // Valid strings with a non-digit added at the end become invalid
        assert(!valid("059a"));

        // Valid strings with punctuation included become invalid
        assert(!valid("055-444-285"));

        // Valid strings with symbols included become invalid
        assert(!valid("055# 444$ 285"));

        // Single zero with space is invalid
        assert(!valid(" 0"));

        // More than a single zero is valid
        assert(valid("0000 0"));

        // Input digit 9 is correctly converted to output digit 9
        assert(valid("091"));

        /*
        Convert non-digits to their ascii values and then offset them by 48 sometimes accidentally declare an invalid string to be valid. 
        This test is designed to avoid that solution.
        */

        // Using ascii value for non-doubled non-digit isn't allowed
        assert(!valid("055b 444 285"));

        // Using ascii value for doubled non-digit isn't allowed
        assert(!valid(":9"));
    }

}
