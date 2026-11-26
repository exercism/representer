module two_fer;

import std.format;

pure string twoFer(immutable string name = "you")
{
    return format("One for %s, one for me.", name);
}

unittest
{
    immutable int allTestsEnabled = 2;

    // No name given
    assert(twoFer() == "One for you, one for me.");

    static if (allTestsEnabled)
    {
        // A name given
        assert(twoFer("Alice") == "One for Alice, one for me.");

        // Another name given
        assert(twoFer("Bob") == "One for Bob, one for me.");
    }

}
