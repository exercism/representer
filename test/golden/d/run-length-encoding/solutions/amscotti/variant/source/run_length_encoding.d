module run_length_encoding;

import std.algorithm : group;
import std.array : array, join, empty, replicate;
import std.algorithm.iteration : map;
import std.format : format;
import std.conv : to;

pure string encode(immutable string input)
{
    string result;
    auto grouping = input.array.group;
    foreach (immutable dchar letter, immutable uint count; grouping)
    {
        if (count > 1)
        {
            result ~= "%d%s".format(count, letter);
        }
        else
        {
            result ~= letter;
        }
    }
    return result;
}

pure string decode(immutable string input)
{
    string i, result;

    foreach (immutable c; input) switch (c)
    {
    case '0': .. case '9':
        i ~= c;
        break;
    default:
        if (i.empty)
        {
            result ~= c;
        }
        else
        {
            result ~= [c].replicate(i.to!int);
            i.length = 0;
        }
        break;
    }

    return result;
}

unittest
{
    immutable int allTestsEnabled = 1;

    // Run-length encode a string

    // Empty string
    assert(encode("") == "");

    static if (allTestsEnabled)
    {
        // Single characters only are encoded without count
        assert(encode("XYZ") == "XYZ");

        // String with no single characters
        assert(encode("AABBBCCCC") == "2A3B4C");

        // Single characters mixed with repeated characters
        assert(encode("WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWB") == "12WB12W3B24WB");

        // Multiple whitespace mixed in string
        assert(encode("  hsqq qww  ") == "2 hs2q q2w2 ");

        // Lowercase characters
        assert(encode("aabbbcccc") == "2a3b4c");

        // Sun-length decode a string

        // Empty string
        assert(decode("") == "");

        // String with no single characters
        assert(decode("XYZ") == "XYZ");

        // Single characters with repeated characters
        assert(decode("2A3B4C") == "AABBBCCCC");

        // Multiple whitespace mixed in string
        assert(decode("12WB12W3B24WB") == "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWB");

        // Multiple whitespace mixed in string
        assert(decode("2 hs2q q2w2 ") == "  hsqq qww  ");

        // Lower case string
        assert(decode("2a3b4c") == "aabbbcccc");

        // Encode and then decode

        // Encode followed by decode gives original string
        assert("zzz ZZ  zZ".encode.decode == "zzz ZZ  zZ");
    }
}
