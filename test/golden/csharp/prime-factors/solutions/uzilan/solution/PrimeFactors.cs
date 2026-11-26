using System;
using System.Linq;

public static class PrimeFactors
{
    public static long[] Factors(long number)
    {
        if (number < 2) return Array.Empty<long>();
        for (var i = 2L; i <= number; i++)
        {
            if (number % i == 0)
            {
                return new[] {i}.Concat(Factors(number / i).ToArray()).ToArray();
            }
        }
        return Array.Empty<long>();
    }
}