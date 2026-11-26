module resistor_color;

static struct ResistorColor {
    static const string[] colors = ["black", "brown", "red", "orange", "yellow", "green", "blue", "violet", "grey", "white"];

    static ubyte colorCode(string colour)
    {
        switch(colour) {
            static foreach(int i; 0..10) {
                case colors[i]: return i;
            }
            default: assert(0);
        }
        assert(0);
    }
}

unittest
{
    immutable int allTestsEnabled = 0;

    // Black
    assert(ResistorColor.colorCode("black") == 0);

    static if (allTestsEnabled)
    {
        // White
        assert(ResistorColor.colorCode("white") == 9);

        // Orange
        assert(ResistorColor.colorCode("orange") == 3);

        // Colors
        assert(ResistorColor.colors == [
                "black", "brown", "red", "orange", "yellow", "green", "blue",
                "violet", "grey", "white"
                ]);
    }

}
