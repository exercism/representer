module perfect_numbers;
import std.exception : basicExceptionCtors;

enum Classification
{
    DEFICIENT,
    PERFECT,
    ABUNDANT
}

Classification classify(int number)
{
    if (number <= 0)
        throw new NaturalNumberException("Number is not a natural number.");

    int sum = 0;
    int current = 1;
    while (sum < number && current < number)
    {
        if (number % current == 0)
            sum += current;
        current++;
    }

    if (sum > number)
        return Classification.ABUNDANT;
    else if (sum < number)
        return Classification.DEFICIENT;
    return Classification.PERFECT;
}

class NaturalNumberException : Exception
{
    ///
    mixin basicExceptionCtors;
}

unittest
{
    import std.exception : assertThrown;

    immutable int allTestsEnabled = 1;

    // Perfect numbers

    // Smallest perfect number is classified correctly
    assert(classify(6) == Classification.PERFECT);

    // Medium perfect number is classified correctly
    assert(classify(28) == Classification.PERFECT);

    // Large perfect number is classified correctly
    assert(classify(33_550_336) == Classification.PERFECT);

    static if (allTestsEnabled)
    {
        // Abundant numbers

        // Smallest abundant number is classified correctly
        assert(classify(12) == Classification.ABUNDANT);

        // Medium abundant number is classified correctly
        assert(classify(30) == Classification.ABUNDANT);

        // Large abundant number is classified correctly
        assert(classify(33_550_335) == Classification.ABUNDANT);

        // Deficient numbers

        // Smallest prime deficient number is classified correctly
        assert(classify(2) == Classification.DEFICIENT);

        // Smallest non-prime deficient number is classified correctly
        assert(classify(4) == Classification.DEFICIENT);

        // Medium deficient number is classified correctly
        assert(classify(32) == Classification.DEFICIENT);

        // Large deficient number is classified correctly
        assert(classify(33_550_337) == Classification.DEFICIENT);

        // Edge case (no factors other than itself) is classified correctly
        assert(classify(1) == Classification.DEFICIENT);

        // Invalid inputs

        // Zero is rejected (not a natural number)
        assertThrown(classify(0));

        // Negative integer is rejected (not a natural number)
        assertThrown(classify(-1));
    }

}
