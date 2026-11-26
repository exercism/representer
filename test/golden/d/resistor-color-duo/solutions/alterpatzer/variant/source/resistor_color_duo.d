module resistor_color_duo;

import std.algorithm.searching : countUntil;

class ResistorColorDuo
{
    static immutable string[] colors = [
	"black", "brown", "red", "orange", "yellow", "green",
	"blue", "violet", "grey", "white"];
    
    static pure long cvalue(string color)
    {
	return colors.countUntil!(c => c == color);
    }

    static pure long value(immutable string[] colorsInput)
    {
        // implement this function
	return 10 * cvalue(colorsInput[0]) + cvalue(colorsInput[1]);
    }
}

unittest
{
    immutable int allTestsEnabled = 1;

    // Brown and black
    assert(ResistorColorDuo.value(["brown", "black"]) == 10);

    static if (allTestsEnabled)
    {
        // Blue and grey
        assert(ResistorColorDuo.value(["blue", "grey"]) == 68);

        // Yellow and violet
        assert(ResistorColorDuo.value(["yellow", "violet"]) == 47);

        // White and red
        assert(ResistorColorDuo.value(["white", "red"]) == 92);

        // Orange and orange
        assert(ResistorColorDuo.value(["orange", "orange"]) == 33);

        // Ignore additional colors
        assert(ResistorColorDuo.value(["green", "brown", "orange"]) == 51);

        // Black and brown, one-digit
        assert(ResistorColorDuo.value(["black", "brown"]) == 2);
    }

}
