using System;
using System.Numerics;

public static class CollatzConjecture
{
    public static BigInteger Steps(int number)
    {
        if (number < 1)
            throw new ArgumentOutOfRangeException();
        else 
            return RecursiveSteps(number,0);
    }
    public static BigInteger RecursiveSteps(int number, BigInteger steps)
    {
        if (number == 1)           
             return steps;
        else if (number%2 == 0) 
            return RecursiveSteps(number/2, steps + 1);
        else
            return RecursiveSteps(number*3+1, steps +1);          
        
    }
}