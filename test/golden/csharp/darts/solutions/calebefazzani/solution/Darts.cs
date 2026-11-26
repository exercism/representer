using System;

public static class Darts
{
    private static double Square(this double val) => Math.Pow(val, 2);
    private static double Sqrt(this double val) => Math.Sqrt(val);
    
    public static int Score(double x, double y)
    {
        var inputSquareSum = x.Square() + y.Square();
        var inputSumSqrt = inputSquareSum.Sqrt();

        if(inputSumSqrt > 10) {
            return 0;
        }
        if(inputSumSqrt > 5) {
            return 1;
        }
        if(inputSumSqrt > 1) {
            return 5;
        }
        return 10;
    }
}
