public static class PythagoreanTriplet
{
    public static IEnumerable<(int a, int b, int c)> TripletsWithSum(int sum)
    {
        for(int x = 1; x <= sum / 3; x++)
        {
            for(int y = x + 1; y < (sum * 2 / 3); y++)
            {
                if ( ((sum * sum) + (2 * x * y)) == 2*sum*(x + y) )
                    yield return (x , y , (sum - x - y));
            }
        }
    }
}