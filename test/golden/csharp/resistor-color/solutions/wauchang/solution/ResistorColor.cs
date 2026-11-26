using System;

public static class ResistorColor
{
    public enum colorCode
    {
        black,brown,red,orange,yellow,green,blue,violet,grey,white
    }
    public static int ColorCode(string color)
    {
        return (int)colorCode.Parse<colorCode>(color);
    }

    public static string[] Colors()
    {
        return Enum.GetNames(typeof(colorCode));
    }
}