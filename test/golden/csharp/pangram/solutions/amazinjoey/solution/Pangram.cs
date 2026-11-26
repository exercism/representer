using System;
using System.Linq;

public static class Pangram
{
    public static bool IsPangram(string input)
    {
        return input.ToLower().Where(c => Char.IsLetter(c)).GroupBy(c => c).Count() == 26;
    }
}