module run_length_encoding;

import std.algorithm.searching: countUntil;
import std.array: appender;
import std.ascii: isDigit;
import std.conv: to;
import std.range: repeat;
import std.utf: byCodeUnit;


string encode(string text) pure
{   
    char prev;  // previously read char
    int count;  // count of consecutive same chars
    auto result = appender!string;  // buffer to store result

    /**
     * Handles case when char is different than prev 
     */
    void handleNewChar()
    {
        if (prev != char.init)
        {
            if (count > 1)
            {
                result.put(to!string(count));
                result.put(prev);
            }
            else
            {
                result.put(prev);
            }
        }
    }

    foreach (c; text.byCodeUnit)
    {
        if (c == prev)
        {
            count++;
        }
        else 
        {
            handleNewChar();
            count = 1;
        }
        prev = c;
    }

    handleNewChar(); // empty the pipe
    return result.data;
}


string decode(string text) pure
{
    auto result = appender!string();

    while (text.length)
    {
        size_t n = text.countUntil!(c => !c.isDigit);
        if (n) // if text starts with n digits
        {
            const num = text[0 .. n].to!int;
            result.put(text[n].repeat(num));
            text = text[n+1 .. $];
        }
        else 
        {
            result.put(text[0]);
            text = text[1 .. $];
        }
    }
    
    return result.data;
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
