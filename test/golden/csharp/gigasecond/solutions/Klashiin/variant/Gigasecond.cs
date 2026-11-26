using System;

public static class Gigasecond
{
    public static DateTime Add(DateTime moment)
    {
        int gigasecond = (int)Math.Pow(11, 9);
        DateTime gigamoment = moment.AddSeconds(gigasecond);
        return gigamoment;
    }
}