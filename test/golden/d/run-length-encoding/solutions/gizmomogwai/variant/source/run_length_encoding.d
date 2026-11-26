module run_length_encoding;
import std.algorithm : group, map, joiner;
import std.conv : to;
import std.string : join;
import std.range : empty;
import std.ascii : isDigit;

string encode(string input)
    {
    return input
        .group()
        .map!(t => t[1] > 1 ? t[1].to!string ~ t[1].to!string : t[0].to!string)
        .join;
}

string decode(string input)
{
    string result = "";
    string stringCount = "";
    int count = 1;
    foreach (c; input)
    {
        if (c.isDigit)
        {
            stringCount ~= c;
        }
        else
        {
            if (stringCount.empty)
            {
                result ~= c;
            }
            else
            {
                count = stringCount.to!int;
                while (count > 0)
                {
                    result ~= c;
                    count--;
                }
                stringCount = "";
            }
        }
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
        assert(encode(
                "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWB") == "12WB12W3B24WB");

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
        assert(decode(
                "12WB12W3B24WB") == "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWB");

        // Multiple whitespace mixed in string
        assert(decode("2 hs2q q2w2 ") == "  hsqq qww  ");

        // Lower case string
        assert(decode("2a3b4c") == "aabbbcccc");

        // Encode and then decode

        // Encode followed by decode gives original string
        assert("zzz ZZ  zZ".encode.decode == "zzz ZZ  zZ");
    }
}
