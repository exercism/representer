using System;
using System.Linq;

public static class Isogram
{
    public static bool IsIsogram(string word) {
        var val = word.ToLower().ToCharArray()
            .Where(c => char.IsLetter(c))
            .Select(c => c.ToString());
        return val.Distinct().ToList().Count == val.ToList().Count;
    }
}
