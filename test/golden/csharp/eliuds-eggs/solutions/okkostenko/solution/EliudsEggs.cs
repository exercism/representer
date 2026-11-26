using System;
using System.Linq;

public static class EliudsEggs
{
    public static int EggCount(int encodedCount) => Convert.ToString(encodedCount, 2).Count(x => x == '1');
}
