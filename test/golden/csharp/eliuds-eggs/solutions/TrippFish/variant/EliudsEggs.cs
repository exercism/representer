using System;

public static class EliudsEggs
{
    public static int EggCount(int encodedCount)
    {
        string binary = Convert.ToString(encodedCount, 2);
        int eggs = 0;
        for (int i = 0; i <= binary.Length; i++)
        {
            if (binary[i].Equals('1'))
            eggs++;
        }
        return eggs;
    }
}
