using System;

public static class NthPrime
{
    public static int Prime(int nth)
    {
        if (nth < 1) throw new ArgumentOutOfRangeException();
        int i = 1;
        int primesFound = 0;
        while (primesFound < nth)
        {
            i++;
            if (IsPrime(i)) primesFound++;
        }
        return i;
    }

    private static bool IsPrime(int n)
    {
        for (int i = 2; i <= Math.Sqrt(n); i++)
            if (n % i == 0) return false;
        return true;
    }
}