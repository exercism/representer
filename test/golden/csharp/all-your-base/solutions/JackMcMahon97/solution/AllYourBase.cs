using System;
using System.Collections.Generic;
using System.Linq;

public static class AllYourBase
{
    public static int[] Rebase(int inputBase, int[] inputDigits, int outputBase)
    {
        if (inputBase < 2 || outputBase < 2) throw new ArgumentException();
        if (!inputDigits.All(d => d < inputBase && d >= 0)) throw new ArgumentException();
        var val = inputDigits
            .Reverse()
            .Select((n, i) => n * (int)Math.Pow(inputBase, i))
            .Sum();

        if (val == 0) return new int[] { 0 };

        List<int> res = new();
        while (val != 0)
        {
            res.Add(val % outputBase);
            val /= outputBase;
        }
        return res.AsEnumerable().Reverse().ToArray();
    }
}