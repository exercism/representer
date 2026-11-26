using System;
using System.Collections.Generic;

public static class Pangram
{
    public static bool IsPangram(string input)
    {
        input = input.ToLower();
        var result = new HashSet<char>();

        for (int i = 0, length = input.Length; i < length; i++)
        {
            if ((input[i] >= 97 && input[i] <= 122))
            {
                result.Add(input[i]);
            }
        }
        return (result.Count == 26);
    }
}
