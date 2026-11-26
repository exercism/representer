using System;
using System.Linq;
using System.Numerics;

public static class AffineCipher
{
    private static string ascii = "abcdefghijklmnopqrstuvwxyz";
    public static string Encode(string plainText, int a, int b)
    {
        if(BigInteger.GreatestCommonDivisor(a, ascii.Length) != 1)
            throw new ArgumentException();
        Console.WriteLine(BigInteger.GreatestCommonDivisor(a, b));
        var result = string.Join("", plainText
                           .Where(c => Char.IsAsciiLetter(c) || Char.IsAsciiDigit(c))
                           .Select(c => {
                               if(Char.IsAsciiLetter(c))
                                   return ascii[(a * ascii.IndexOf(Char.ToLower(c)) + b) % ascii.Length];
                               return c;
                            }));
        return string.Join("", result.Chunk(5).SelectMany(str => string.Join("", str) + " ")).Trim();
    }

    public static string Decode(string cipheredText, int a, int b)
    {
        if(BigInteger.GreatestCommonDivisor(a, ascii.Length) != 1)
            throw new ArgumentException();
        Console.WriteLine(BigInteger.GreatestCommonDivisor(a, b));
        int x = Enumerable.Range(0, 10000).First(x => (a * x) % ascii.Length == 1);
        string cipheredWOSpaces = string.Join("", cipheredText.Split(" ").Where(str => !str.Equals(" ")));
        return string.Join("", cipheredWOSpaces
                               .Select(c => {
                                   if(Char.IsAsciiDigit(c))
                                       return c;
                                   int index = x * (ascii.IndexOf(Char.ToLower(c)) - b) % ascii.Length;
                                   index = (index < 0 ) ? ascii.Length + index : index;
                                   return ascii[index];
                                }));
    }
}
