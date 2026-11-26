using System;

public class SpaceAge
{
    int seconds;
    public SpaceAge(int seconds)
    {
        this.seconds = seconds;
    }

    public double OnEarth()
    {
        return Math.Round((double)seconds /31557600, 2, MidpointRounding.AwayFromZero);
    }

    public double OnMercury()
    {
        return Math.Round(seconds / (31557600 * 0.2408467), 2, MidpointRounding.AwayFromZero);
    }

    public double OnVenus()
    {
        return Math.Round(seconds / (31557600 * 0.61519726), 2, MidpointRounding.AwayFromZero);
    }

    public double OnMars()
    {
        return Math.Round(seconds / (31557600 * 1.8808158), 2, MidpointRounding.AwayFromZero);
    }

    public double OnJupiter()
    {
        return Math.Round(seconds / (31557600 * 11.862615), 2, MidpointRounding.AwayFromZero);
    }

    public double OnSaturn()
    {
        return Math.Round(seconds / (31557600 * 29.447498), 2, MidpointRounding.AwayFromZero);
    }

    public double OnUranus()
    {
        return Math.Round(seconds / (31557600 * 84.016846), 2, MidpointRounding.AwayFromZero);
    }

    public double OnNeptune()
    {
        return Math.Round(seconds / (31557600 * 164.79132), 2, MidpointRounding.AwayFromZero);
    }
}