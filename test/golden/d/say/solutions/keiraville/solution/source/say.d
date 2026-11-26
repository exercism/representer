module say;

import std.array : appender;

immutable string[] names = [
    "zero ",
    "one ",
    "two ",
    "three ",
    "four ",
    "five ",
    "six ",
    "seven ",
    "eight ",
    "nine ",
    "ten ",
    "eleven ",
    "twelve ",
    "thirteen ",
    "fourteen ",
    "fifteen ",
    "sixteen ",
    "seventeen ",
    "eighteen ",
    "nineteen ",
];

immutable string[] decadeNames = [
    "zero",
    "ten",
    "twenty",
    "thirty",
    "forty",
    "fifty",
    "sixty",
    "seventy",
    "eighty",
    "ninety",
];

pure string pronounce(long number)
{
    auto builder = appender!string();
    int hundreds = cast(int)(number) / 100;
    int units = cast(int)(number) % 100;
    if (hundreds != 0)
    {
        builder.put(names[hundreds]);
        builder.put("hundred ");
    }
    if (units >= 20)
    {
        builder.put(decadeNames[units / 10]);
        if (units % 10 != 0)
        {
            builder.put("-");
            builder.put(names[units % 10]);
        }
        else
        {
            builder.put(" ");
        }
    }
    else if (units != 0)
    {
        builder.put(names[units]);
    }
    return builder.data;
}

pure string say(long number)
{
    if (number < 0 || number > 999999999999)
    {
        throw new Exception("input out of range");
    }
    if (number == 0)
    {
        return "zero";
    }
    auto builder = appender!string();
    long billions = number / 1000000000;
    long millions = number / 1000000 % 1000;
    long thousands = number / 1000 % 1000;
    long units = number % 1000;
    if (billions != 0)
    {
        builder.put(pronounce(billions));
        builder.put("billion ");
    }
    if (millions != 0)
    {
        builder.put(pronounce(millions));
        builder.put("million ");
    }
    if (thousands != 0)
    {
        builder.put(pronounce(thousands));
        builder.put("thousand ");
    }
    if (units != 0)
    {
        builder.put(pronounce(units));
    }
    string result = builder.data;
    return result[0 .. $ - 1];
}

unittest
{
    import std.algorithm.comparison : equal;
    import std.exception : assertThrown;

    immutable int allTestsEnabled = 0;

    // Zero
    assert(equal("zero",
                 say(0L)));

    static if (allTestsEnabled)
    {
        // One
        assert(equal("one",
                     say(1L)));

        // Fourteen
        assert(equal("fourteen",
                     say(14L)));

        // Twenty
        assert(equal("twenty",
                     say(20L)));

        // Twenty-two
        assert(equal("twenty-two",
                     say(22L)));

        // Thirty
        assert(equal("thirty",
                     say(30L)));

        // Ninety-nine
        assert(equal("ninety-nine",
                     say(99L)));

        // One hundred
        assert(equal("one hundred",
                     say(100L)));

        // One hundred twenty-three
        assert(equal("one hundred twenty-three",
                     say(123L)));

        // Two hundred
        assert(equal("two hundred",
                     say(200L)));

        // Nine hundred ninety-nine
        assert(equal("nine hundred ninety-nine",
                     say(999L)));

        // One thousand
        assert(equal("one thousand",
                     say(1000L)));

        // One thousand two hundred thirty-four
        assert(equal("one thousand two hundred thirty-four",
                     say(1234L)));

        // One million
        assert(equal("one million",
                     say(1000000L)));

        // One million two thousand three hundred forty-five
        assert(equal("one million two thousand three hundred forty-five",
                     say(1002345L)));

        // One billion
        assert(equal("one billion",
                     say(1000000000L)));

        // A big number
        assert(equal("nine hundred eighty-seven billion six hundred fifty-four million three hundred twenty-one thousand one hundred twenty-three",
                     say(987654321123L)));

        // Numbers below zero are out of range
        assertThrown(say(-1L));

        // Numbers above 999,999,999,999 are out of range
        assertThrown(say(1000000000000L));
    }
}
