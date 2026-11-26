using System;

public enum Classification
{
    Perfect,
    Abundant,
    Deficient
}

public static class PerfectNumbers
{
    public static Classification Classify(int number)
    {
        if (number < 1 )
            throw new ArgumentOutOfRangeException();
        else if (number == 1)
            return Classification.Deficient;
        
        int aliquotSum = 1;

        for (int i = 2; i <= number/2 ;i++)
        {
            if (number%i == 0 )            
                aliquotSum += i;               
        }                        

        return (aliquotSum-number) switch 
        {
                < 0 => Classification.Deficient,                    
                0 => Classification.Perfect,                
                > 0 => Classification.Abundant                
        };                  
    }
}
