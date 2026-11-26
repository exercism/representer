using System;
using System.Collections.Generic;

public static class Pangram
{
    private static List<char> alphebet = new()
    {
        'a','b','c','d','e','f','g','h','i','j',
        'k','l','m','n','o','p','q','r','s','t',
        'u','v','w','x','y','z'
    };

    public static bool IsPangram(string input)
    {
        foreach (var ch in alphebet)
            if (!input.ToLower().Contains(ch)) return false;

        return true;
    }
}
