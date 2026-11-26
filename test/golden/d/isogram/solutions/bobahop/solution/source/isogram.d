module isogram;
// note the extra tests for Unicode

import std.array : array;
import std.regex : regex, replaceAll;
import std.uni : byGrapheme, toLower;

@safe bool isIsogram(string phrase)
{
    phrase = replaceAll(phrase.toLower, regex(r"\W"), "");
    auto outer = phrase.byGrapheme.array;
    auto stop = outer.length;
    if (stop == 0)
        return true;
    auto inner = outer[0 .. stop];

    // not the most efficient algorithm, but handles Unicode diacritics.
    foreach (i; 0 .. stop)
    {
        foreach (j; i + 1 .. stop)
        {
            if (outer[i] == inner[j])
            {
                return false;
            }
        }
    }
    return true;
}

unittest
{
    immutable int allTestsEnabled = 1;

    // Empty string
    assert(isIsogram(""));

    static if (allTestsEnabled)
    {
        // Isogram with only lower case characters
        assert(isIsogram("isogram"));

        // Word with one duplicated character
        assert(!isIsogram("eleven"));

        // Word with one duplicated character from the end of the alphabet
        assert(!isIsogram("zzyzx"));

        // Longest reported english isogram
        assert(isIsogram("subdermatoglyphic"));

        // Word with duplicated character in mixed case
        assert(!isIsogram("Alphabet"));

        // Word with duplicated character in mixed case, lowercase first
        assert(!isIsogram("alphAbet"));

        // Hypothetical isogrammic word with hyphen
        assert(isIsogram("thumbscrew-japingly"));

        // Hypothetical word with duplicated character following hyphen
        assert(!isIsogram("thumbscrew-jappingly"));

        // Isogram with duplicated hyphen
        assert(isIsogram("six-year-old"));

        // Made-up name that is an isogram
        assert(isIsogram("Emily Jung Schwartzkopf"));

        // Duplicated character in the middle
        assert(!isIsogram("accentor"));

        // Same first and last characters
        assert(!isIsogram("angola"));

        // Unicode with doubled diacritic
        assert(!isIsogram("Bén y Amélie"));

        // Unicode with diacritic
        assert(isIsogram("-Amélie-")); 

    }
}
