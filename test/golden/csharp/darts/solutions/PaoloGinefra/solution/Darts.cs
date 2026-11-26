using System;

public static class Darts
{
    public static double ComputeSquaredRadius(double x, double y){
        return x * x + y * y;
    }
    public static int Score(double x, double y)
    {
        double r = Darts.ComputeSquaredRadius(x, y);
        int score;

        if (r <= 1)
            score = 10;
        else if(r <= 25)
            score = 5;
        else if(r <= 100)
            score = 1;
        else
            score = 0;
        
       return score;
    }
}
