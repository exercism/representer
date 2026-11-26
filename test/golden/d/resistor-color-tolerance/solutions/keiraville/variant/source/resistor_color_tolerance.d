module resistor_color_tolerance;

import std.algorithm.searching : countUntil;

class ResistorColorTolerance
{
    static pure string label(immutable string[] bands)
    {
        if (bands.length == 1)
            return "0 ohms";

        immutable tolerance = tolerances[toleranceColors.countUntil(bands[$ - 1])];
        long multiplier = colors.countUntil(bands[$ - 2]) + 1;
        immutable char first = digit(bands[1]);
        immutable char second = digit(bands[1]);
        char third = '0';
        if (bands.length == 5)
        {
            third = digit(bands[2]);
            ++multiplier;
        }

        string answer;
        final switch (multiplier % 3)
        {
        case 0:
            answer ~= first;
            if (second != '0' || third != '0')
                answer ~= ['.', second];
            if (third != '0')
                answer ~= third;
            break;
        case 1:
            if (first != '0')
                answer ~= first;
            answer ~= second;
            if (third != '0')
                answer ~= ['.', third];
            break;
        case 2:
            if (first != '0')
                answer ~= first;
            if (first != '0' || second != '0')
                answer ~= second;
            answer ~= third;
            break;
        }

        return answer ~ " " ~ prefixes[multiplier / 3] ~ "ohms " ~ tolerance;
    }

    private static pure char digit(string color)
    {
        return cast(char)('0' + colors.countUntil(color));
    }

    private static immutable colors = [
        "black", "brown", "red", "orange",
        "yellow", "green", "blue", "violet",
        "grey", "white"
    ];

    private static immutable toleranceColors = [
        "grey", "violet", "blue", "green",
        "brown", "red", "gold", "silver"
    ];

    private static immutable tolerances = [
        "±0.05%", "±0.1%", "±0.25%", "±0.5%",
        "±1%", "±2%", "±5%", "±10%"
    ];

    private static immutable prefixes = ["", "kilo", "mega", "giga"];
}

unittest
{
    immutable int allTestsEnabled = 0;

    // Orange, orange, black and red
    assert(ResistorColorTolerance.label(["orange", "orange", "black", "red"]) == "33 ohms ±2%");

    static if (allTestsEnabled)
    {
        // Blue, gray, brown and violet
        assert(ResistorColorTolerance.label(["blue", "grey", "brown", "violet"]) == "680 ohms ±0.1%");

        // Red, black, red and green
        assert(ResistorColorTolerance.label(["red", "black", "red", "green"]) == "2 kiloohms ±0.5%");

        // Green, brownm orange and grey
        assert(ResistorColorTolerance.label(["green", "brown", "orange", "grey"]) == "51 kiloohms ±0.05%");

        // Only one band
        assert(ResistorColorTolerance.label(["black"]) == "0 ohms");

        // Orange, orange, yellow, black and brown
        assert(ResistorColorTolerance.label(["orange", "orange", "yellow", "black", "brown"]) == "334 ohms ±1%");

        // Red, green, yellow, yellow and brown
        assert(ResistorColorTolerance.label(["red", "green", "yellow", "yellow", "brown"]) == "2.54 megaohms ±1%");

        // Blue, gray, white, brown and brown
        assert(ResistorColorTolerance.label(["blue", "grey", "white", "brown", "brown"]) == "6.89 kiloohms ±1%");

        // Violet, orange, red and gray
        assert(ResistorColorTolerance.label(["violet", "orange", "red", "grey"]) == "7.3 kiloohms ±0.05%");

        // Brown, red, orange, green and blue
        assert(ResistorColorTolerance.label(["brown", "red", "orange", "green", "blue"]) == "12.3 megaohms ±0.25%");

        // Brown, black, brown, yellow and violet
        assert(ResistorColorTolerance.label(["brown", "black", "brown", "yellow", "violet"]) == "1.01 megaohms ±0.1%");

        // Brown, black, red and red
        assert(ResistorColorTolerance.label(["brown", "black", "red", "red"]) == "1 kiloohms ±2%");

        // Orange, orange, red and gold
        assert(ResistorColorTolerance.label(["orange", "orange", "red", "gold"]) == "3.3 kiloohms ±5%");

        // Orange, orange, green and silver
        assert(ResistorColorTolerance.label(["orange", "orange", "green", "silver"]) == "3.3 megaohms ±10%");

        // White, white, violet and green
        assert(ResistorColorTolerance.label(["white", "white", "violet", "green"]) == "990 megaohms ±0.5%");

        // White, white, grey and blue
        assert(ResistorColorTolerance.label(["white", "white", "grey", "blue"]) == "9.9 gigaohms ±0.25%");
    }
}
