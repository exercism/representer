using System;
using System.Collections.Generic;
using System.Linq;

public static class Etl
{
    public static Dictionary<string, int> Transform(Dictionary<int, string[]> old)
    {
        var result = new Dictionary<string, int>();
        foreach(var DLetterArray in old) {
            foreach(var letter in DLetterArray.Value) {
                result.Add(letter.ToLower (), DLetterArray.Key);
            }
        }
        return result;
    }
}
