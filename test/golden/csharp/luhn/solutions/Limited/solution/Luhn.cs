using System;
using System.Linq;

public static class Luhn
{
    public static bool IsValid(string number)
    {
        number = number.Replace(" ", "");

        if(number.Length < 2 || !number.All(char.IsDigit))
            return false;

        return number
            .Reverse()
            .Select(n => int.Parse(n.ToString()))
            .Select((n, index) => n * (index % 2 + 1))
            .Select(n => n > 9 ? n - 9 : n)
            .Sum() % 10 == 0;
    }
}