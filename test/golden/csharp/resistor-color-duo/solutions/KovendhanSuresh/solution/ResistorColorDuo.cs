using System;
using System.Collections.Generic;

public static class ResistorColorDuo
{
    private static int firstValue = 0;

    private static int secondValue = 1;

    private static Dictionary<string, int> collection = new Dictionary<string, int>()
    {
        {"black",0},
        {"brown",1},
        {"red",2},
        {"orange",3},
        {"yellow",4},
        {"green",5},
        {"blue",6},
        {"violet",7},
        {"grey",8},
        {"white",9}
    };

    public static int Value(string[] colors)
    {
        var value1 = collection[colors[firstValue]];
        var value2 = collection[colors[secondValue]];
        var result = (value1 * 10) + value2;
        return result;
    }
}
