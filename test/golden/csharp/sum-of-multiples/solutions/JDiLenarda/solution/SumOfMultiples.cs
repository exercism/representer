using System;
using System.Collections.Generic;
using System.Linq;

public static class SumOfMultiples
{
    public static int Sum(IEnumerable<int> multiples, int max) =>
        Enumerable.Range(0, max)
            .Where(x => multiples.Any(y => y != 0 && x % y == 0))
            .Sum();
}