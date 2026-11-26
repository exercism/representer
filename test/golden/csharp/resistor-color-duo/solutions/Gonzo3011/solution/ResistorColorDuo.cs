using System;

public static class ResistorColorDuo
{
    private enum ResistorColors
    {
        Black,
        Brown,
        Red,
        Orange,
        Yellow,
        Green,
        Blue,
        Violet,
        Grey,
        White
    }

    public static int Value(string[] colors)
    {
        var value = string.Empty;

        for (int i = 0; i < 2; i++)
        {
            value += ColorCode(colors[i]);
        }

        return int.Parse(value);
    }

    private static int ColorCode(string color) => (int)Enum.Parse(typeof(ResistorColors), color, true);
}
