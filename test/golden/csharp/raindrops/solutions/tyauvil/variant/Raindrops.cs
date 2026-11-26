using System;
using System.Linq;
using System.Collections.Generic;

public static class Raindrops
{
    private static readonly Dictionary<int, string> drops = new Dictionary<int, string> {
        {3, "Pling"}, {5, "Plang"}, {7, "Plong"},
    };
    public static string Convert(int number) =>
        (number % 3 != 0 || number % 5 != 0 && number % 7 != 0)
        ? number.ToString()
        : string.Join("", drops.Keys.Where(k => number % k == 0)
                                    .Select(k => drops[k])
                                    .ToArray());
}
