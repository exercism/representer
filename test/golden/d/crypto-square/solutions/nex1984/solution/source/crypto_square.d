module crypto;
import std.algorithm;
import std.range;
import std.conv;
import std.string;

ulong sqrt(ulong n) {
    ulong r = 1, tmp1,tmp2;
    while(true) {
        r = r/2 + n/(2*r);
        tmp1 = r*r;
        tmp2 = (r+1)*(r+1);
        //writeln(r," ", tmp1, " ", tmp2);
        if(tmp1 <= n && tmp2 >= n) { break; }
    }
    return r;
}

struct Cipher {
    string s;
    string n;
    string ct;
    ulong r;
    ulong c;
    string[] chnks;
    string[] trans;
    auto normalizePlainText() { return n; }
    auto size() { return c; }
    auto plainTextSegments() { return chnks; }
    auto cipherText() { return ct; }
    Normalized normalize;
    static struct Normalized {
        string ct;
        auto cipherText() { return ct; }
    }
    this(string s) {
        foreach(x;s) {
            if(     (x>='a' && x <='z')
                ||  (x>='0' && x <='9')
            ) {
                n ~= x;
            }
            else if(x>='A' && x <='Z') {
                n ~= cast(char)(x+'a'-'A');
            }
        }
        c=r = sqrt(n.length);
        if(c*r<n.length) { c++; }
        if(c*r<n.length) { r++; }
        chnks = n.chunks(c).map!(to!string).array;
        assert(chnks.length == r);
        chnks[$-1] ~= iota(c-chnks[$-1].length).map!(x=>' ').array.to!string;
        char[][] tmp;
        tmp.length = c;
        foreach(ref x; tmp) { x.length =r; }
        foreach(i,row; chnks) {
            foreach(j,x; row) {
                tmp[j][i] = x;
            }
        }
        foreach(row; tmp) { trans ~= row.to!string.strip;}
        chnks[$-1] = chnks[$-1].strip;
        foreach(i,row; trans) {
            ct ~= row;
            normalize.ct ~= row;
            if(i +1 < trans.length) { normalize.ct ~= " "; }
        }
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

    static if (allTestsEnabled)
    {
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
            const string[] expected = [
                "neverv", "exthin", "eheart", "withid", "lewoes"
            ];
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
            assert("msemo aanin dnin ndla etlt shui" == theCipher.normalize.cipherText());
        }

        // normalized_Cipher_text2
        {
            auto theCipher = new Cipher("Vampires are people too!");
            assert("vrel aepe mset paoo irpo" == theCipher.normalize.cipherText());
        }
    }

}
