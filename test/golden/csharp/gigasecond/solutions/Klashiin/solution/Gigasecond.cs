using System;

public static class Gigasecond
{
    public static DateTime Add(DateTime moment)
    {
        int gigasecond = (int)Math.Pow(10, 9);
        DateTime gigamoment = moment.AddSeconds(gigasecond);
        return gigamoment;
    }
}