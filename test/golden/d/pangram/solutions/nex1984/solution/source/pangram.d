module pangram;
import std.range;
import std.algorithm;
import std.uni;

bool isPangram(string s) {
    bool[] found = iota(26).map!(x=>false).array;
    foreach(x; s) {
        if(x >= 'a' && x<='z') { found[x-'a'] = true; }
        else if(x >= 'A' && x<='Z') { found[x-'A'] = true; }
    }
    foreach(b; found) { if(!b) { return false; } }
    return true;
}

bool isPangramUFC(string s) {
    return s.filter!(x=>(x>='a' && x<='z') || (x>='A' && x<='Z'))
            .map!(x=>x.toLower)
            .array
            .sort
            .uniq
            .walkLength == 26;
}


unittest
{
    immutable bool allTestsEnabled = false;

    // Empty sentence
    assert(!isPangram(""));

    static if (allTestsEnabled)
    {
        // Perfect lower case
        assert(isPangram("abcdefghijklmnopqrstuvwxyz"));

        // Only lower case
        assert(!isPangram("the quick brown fish jumps over the lazy dog"));

        // Missing the letter 'x'
        assert(!isPangram("a quick movement of the enemy will jeopardize five gunboats"));

        // Missing the letter 'h'
        assert(!isPangram("five boxing wizards jump quickly at it"));

        // With underscores
        assert(isPangram("the_quick_brown_fox_jumps_over_the_lazy_dog"));

        // With numbers
        assert(isPangram("the 1 quick brown fox jumps over the 2 lazy dogs"));

        // Missing letters replaced by numbers
        assert(!isPangram("7h3 qu1ck brown fox jumps ov3r 7h3 lazy dog"));

        // Mixed case and punctuation
        assert(isPangram("\"Five quacking Zephyrs jolt my wax bed\""));

        // Case insensitive
        assert(!isPangram("the quick brown fox jumps over with lazy FX"));
    }
}
