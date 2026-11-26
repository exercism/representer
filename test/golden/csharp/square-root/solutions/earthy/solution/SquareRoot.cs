public static class SquareRoot
{
    public static int Root(int number)
    {
        int sqrt = 0;

        while(sqrt * sqrt != number)
        {
            sqrt++;
        }
        
        return sqrt;
    }
}
