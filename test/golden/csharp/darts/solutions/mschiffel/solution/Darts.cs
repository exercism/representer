using System;

public static class Darts
{
    public static int Score(double x, double y)
    {
        double radius = Radius(x, y);

        if (radius > 10)
        {
            return 0;
        }
        else if (radius > 5)
        {
            return 1;
        }
        else if (radius > 1)
        {
            return 5;
        }
        else
        {
            return 10;
        }
    }

    private static double Radius(double x, double y)
    {
        return Math.Sqrt(Math.Pow(x, 2f) + Math.Pow(y, 2f));
    }
}
