using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

public static class CryptoSquare
{
    public static string NormalizedPlaintext(string plaintext)
    {
        Regex rx = new Regex(@"[^\w]*");
        return rx.Replace(plaintext, string.Empty).ToLower();
    }

    public static IEnumerable<string> PlaintextSegments(string plaintext, (int C, int R) p)
    {
        for (int i = 0; i < p.R; i++)
        {
            yield return p.C * i + p.C > plaintext.Length 
                ? plaintext[(p.C * i)..] 
                : plaintext.Substring(p.C * i, p.C);
        }
    }

    public static IEnumerable<char> Encoded(string plaintext, int r)
    {
        var index = 0;
        foreach (char c in plaintext)
        {
            yield return c;
            index++;
            if (index % r == 0 && index != plaintext.Length)
                yield return ' ';
        }
    }
    public static (int C, int R) ComputeRectangle(int lenght)
    {
        for (int i = 0; i <= lenght; i++)
            for (int j = 0; j <= i; j++)
            {
                if (i * j >= lenght && i - j <= 1)
                    return (i, j);
            }
        return (0, 0);
    }

    public static string Ciphertext(string plaintext)
    {
        plaintext = NormalizedPlaintext(plaintext);
        if (plaintext.Length == 0) return string.Empty;

        var (C, R) = ComputeRectangle(plaintext.Length);
        var segments = PlaintextSegments(plaintext, (C, R)).ToArray();
        if (segments.Length == 0) return string.Empty;
        var result = new StringBuilder();
        for (int index = 0; index < segments[0].Length; index++)
        {
            for (int i = 0; i < segments.Length; i++)
            {
                if (segments.Length > i)
                {
                    if (segments[i].Length > index)
                        result.Append(segments[i][index]);
                    else
                        result.Append(' ');
                }
            }
        }
        return new string(Encoded(result.ToString(), R).ToArray());
    }
}