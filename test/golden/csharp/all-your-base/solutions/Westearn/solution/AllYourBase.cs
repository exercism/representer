public static class AllYourBase
{
    public static int[] Rebase(int inputBase, int[] inputDigits, int outputBase)
    {
        if (inputBase < 2 
            || inputDigits.Any(x => x >= inputBase || x < 0)
            || outputBase < 2) throw new ArgumentException();
        
        if (inputDigits.Length == 0) return new[] { 0 };

        int b = inputDigits.Aggregate(0, (acc, x) => acc * inputBase + x);

        List<int> result = new List<int>();

        do
        {
            result.Add(b % outputBase);
            b /= outputBase;
        }
        while (b > 0);

        result.Reverse();
        return result.ToArray();
    }
}