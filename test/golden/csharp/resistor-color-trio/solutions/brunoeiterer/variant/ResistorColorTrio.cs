using System;
using System.Linq;

public static class ResistorColorTrio
{
    public static string Label(string[] colors) {
        var value = ((ColorToValue(colors[0]) * 10 + ColorToValue(colors[1])) * Math.Pow(10, ColorToValue(colors[2]))).ToString();
        var trailingZeroes = value.Reverse().TakeWhile(c => c != '0').Count();
        trailingZeroes = (int)(Math.Round(trailingZeroes / 3.0) * 3);

        return $"{new string(value.Take(value.Length - trailingZeroes).ToArray())} {Prefix(trailingZeroes)}ohms";

    } 

    private static int ColorToValue(string color) => color switch {
        "black" => 0,
        "brown" => 1,
        "red" => 2,
        "orange" => 3,
        "yellow" => 4,
        "green" => 5,
        "blue" => 6,
        "violet" => 7,
        "grey" => 8,
        "white" => 9,
        _ => throw new ArgumentOutOfRangeException($"{color} is not a valid {nameof(color)}")
    };

    private static string Prefix(int numberOfZeroes) => numberOfZeroes switch {
        0 => "",
        3 => "kilo",
        6 => "mega",
        9 => "giga",
        _ => throw new ArgumentOutOfRangeException("Too many zeroes")
    };
}
