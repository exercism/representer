using System;

public static class DifferenceOfSquares
{
    public static int CalculateSquareOfSum(int max)
    {
        int counter=0;
        int sum=0;   
        int SumOfSquare=0;
        
        while(counter<max)
        {
            counter++;
            sum=sum+counter;
        }
    SumOfSquare=sum*sum;
    return SumOfSquare;
    }

    public static int CalculateSumOfSquares(int max)
    {
        int counter=0;
        int SumOfSquare=0;
        while(counter<max)
        {
            counter++;
            SumOfSquare+=counter*counter;
        }
    return SumOfSquare;
    }

    public static int CalculateDifferenceOfSquares(int max)
    {
        int counter=0;
        int sum=0;   
        int SumOfSquare=0;
        int SquareOfSum=0;
        int Diffrence=0;
        
        while(counter<max)
        {
            counter++;
            sum+=counter;
            SumOfSquare+=counter*counter;
        }
    SquareOfSum=sum*sum;
        Diffrence=SquareOfSum+SumOfSquare;
    return Diffrence;
    }
}