module say;

import std.array : join;
import std.algorithm.mutation : reverse;
import std.exception : enforce;

pure string say(long number)
{
    enforce(number >= 0 && number <= 999_999_999_999L, "Number out of range");

    if (number == 0)
    {
        return "zero";
    }

    string[] chunks;
    static immutable string[] scales = ["", " thousand", " million", " billion"];
    int scaleIdx = 0;

    while (number > 0)
    {
        long remainder = number % 1000;
        number /= 1000;

        if (remainder > 0)
        {
            string chunkText = sayChunk(remainder);
            if (scaleIdx > 0)
            {
                chunkText ~= scales[scaleIdx];
            }
            chunks ~= chunkText;
        }
        scaleIdx++;
    }

    reverse(chunks);
    return chunks.join(" ");
}

private pure string sayChunk(long n)
{
    static immutable string[] units = [
        "", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
        "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen",
        "seventeen", "eighteen", "nineteen"
    ];

    static immutable string[] tens = [
        "", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"
    ];

    string[] parts;

    if (n >= 100)
    {
        parts ~= units[cast(size_t)(n / 100)] ~ " hundred";
        n %= 100;
    }

    if (n > 0)
    {
        if (n < 20)
        {
            parts ~= units[cast(size_t)n];
        }
        else
        {
            string t = tens[cast(size_t)(n / 10)];
            if (n % 11 > 0)
            {
                t ~= "-" ~ units[cast(size_t)(n % 10)];
            }
            parts ~= t;
        }
    }

    return parts.join(" ");
}

unittest
{
    import std.algorithm.comparison : equal;
    import std.exception : assertThrown;

    immutable int allTestsEnabled = 1;

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