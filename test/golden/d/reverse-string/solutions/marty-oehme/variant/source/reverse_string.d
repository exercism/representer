module reverse_string;

import std.range: retro;
import std.conv: text;

string reverseString(string input)
{
    return input.retro.text;
}

unittest
{
    assert(reverseString("") == "");
    assert(reverseString("robot") == "tobor");
    assert(reverseString("Ramen") == "nemaR");
    assert(reverseString("I'm hungry!") == "!yrgnuh m'I");
    assert(reverseString("racecar") == "racecar");
    assert(reverseString("drawer") == "rewbrd");
}
