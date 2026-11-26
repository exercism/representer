using System;
using System.Linq;

public static class BinarySearch
{
    public static int Find(int[] input, int value)
    {
        Array.Sort(input);
        var tempArr = input;
        int i = tempArr.Length;
        
        while (i > 0)
        {
            i = i / 2;

            if (tempArr[i] == value) return Array.IndexOf(input, value);
            else if (value >= tempArr[i])
            {
                tempArr = tempArr.Skip(i+1).Take(tempArr.Length).ToArray();
            }
            else
            {
                tempArr = tempArr.Skip(0).Take(i).ToArray();
            }
        }
        return -1;
    }
}