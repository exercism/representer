module crypto;

import std.ascii : isDigit, isAlpha, toLower;
import std.string : strip;
import std.array : appender;
import std.conv : to;
import std.algorithm : min;

class Cipher
{
    string text;
    int r, c;

    this(string st)
    {
        text = st;
        doNormalize();
        doCalculateSize();
    }

    void doNormalize()
    {
        auto w = appender!string;
        w.reserve(100);
        foreach (ch; text)
        {
            if (isDigit(ch))
            {
                w ~= ch;
            }
            else if (isAlpha(ch))
            {
                w ~= toLower(ch);
            }
        }
        text = w.data;
    }

    string normalizePlainText()
    {
        return text;
    }

    void doCalculateSize()
    {
        foreach (n; 2 .. 100)
        {
            if (n * n >= text.length)
            {
                r = n;
                break;
            }
        }
    }

    int size()
    {
        return r;
    }

    string[] plainTextSegments()
    {
        string[] res;
        int len, i;
        len = text.length.to!int;
        for (i = 1; len > 0;)
        {
            int w = min(i + r, text.length);
            res ~= text[i .. w];
            len -= r;
            i += r;
        }
        return res;
    }

    string doCipher(string pad)
    {
        auto w = appender!string;
        immutable auto len = text.length;
        ulong ii;
        foreach (i; 0 .. r)
        {
            foreach (j; 0 .. r)
            {
                ii = j * r + i;
                if (ii >= len)
                {
                    w ~= pad;
                    break;
                }
                w ~= text[ii];
            }
        }
        return strip(w.data);
    }

    string cipherText()
    {
        return doCipher("");
    }

    string normalizedCipherText()
    {
        return doCipher(" ");
    }
}

unittest
{
    immutable int allTestsEnabled = 0;

    // normalize_strange_characters
    {
        auto theCipher = new Cipher("s#$%^&plunk");
        assert("splunk" == theCipher.normalizePlainText());
    }

    // normalize_numbers
    {
        auto theCipher = new Cipher("1, 2, 3 GO!");
        assert("123go" == theCipher.normalizePlainText());
    }

    // size_of_small_square
    {
        auto theCipher = new Cipher("1234");
        assert(2U == theCipher.size());
    }

    // size_of_slightly_larger_square
    {
        auto theCipher = new Cipher("123456789");
        assert(3U == theCipher.size());
    }

    // size_of_non_perfect_square
    {
        auto theCipher = new Cipher("123456789abc");
        assert(4U == theCipher.size());
    }

    // size_of_non_perfect_square_less
    {
        auto theCipher = new Cipher("zomgzombies");
        assert(4U == theCipher.size());
    }

    // plain_text_segments_from_phrase
    {
        const string[] expected = ["neverv", "exthin", "eheart", "withid", "lewoes"];
        auto theCipher = new Cipher("Never vex thine heart with idle woes");
        const auto actual = theCipher.plainTextSegments();

        assert(expected == actual);
    }

    // plain_text_segments_from_complex_phrase
    {
        const string[] expected = ["zomg", "zomb", "ies"];
        auto theCipher = new Cipher("ZOMG! ZOMBIES!!!");
        const auto actual = theCipher.plainTextSegments();

        assert(expected == actual);
    }

    // Cipher_text_short_phrase
    {
        auto theCipher = new Cipher("Time is an illusion. Lunchtime doubly so.");
        assert("tasneyinicdsmiohooelntuillibsuuml" == theCipher.cipherText());
    }

    // Cipher_text_long_phrase
    {
        auto theCipher = new Cipher("We all know interspecies romance is weird.");
        assert("wneiaweoreneawssciliprerlneoidktcms" == theCipher.cipherText());
    }

    // normalized_Cipher_text1
    {
        auto theCipher = new Cipher("Madness, and then illumination.");
        assert("msemo aanin dnin ndla etlt shui" == theCipher.normalizedCipherText());
    }

    // normalized_Cipher_text2
    {
        auto theCipher = new Cipher("Vampires are people too!");
        assert("vrel aepe mset paoo irpo" == theCipher.normalizedCipherText());
    }

    static if (allTestsEnabled)
    {
    }

}
