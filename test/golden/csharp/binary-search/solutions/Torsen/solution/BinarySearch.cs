using System;

public static class BinarySearch
{
    
    public static int Find(int[] input, int value)
    {
        int Left = 0;
        int Right = input.Length-1;
        while (Left <= Right)
        {
            int m = (int)Math.Floor((Left + Right)/2d);
            if (value < input[m]) Right = m - 1;
            if (value > input[m]) Left = m + 1;
            if (value == input[m]) return m;
        }
        return -1;
    }
}