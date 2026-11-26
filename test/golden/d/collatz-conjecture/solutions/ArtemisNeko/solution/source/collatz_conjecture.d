module collatz_conjecture;

import std.exception : enforce;

int steps(int number)
{
    enforce(number > 0);
    return _steps(number, 0);
}

int _steps(int number, int step)
{
    if (number == 1)
    {
        return step;
    }
    else if (number % 2 == 0)
    {
        return _steps(number / 2, step + 1);
    }
    else
    {
        return _steps((3 * number) + 1, step + 1);
    }
}

unittest
{
    import std.exception : assertThrown;

    const int allTestsEnabled = 0;

    // Zero steps for one
    assert(steps(1) == 0);

    static if (allTestsEnabled)
    {
        assert(steps(1) == 0);
        // Divide if even
        assert(steps(16) == 4);

        // Even and odd steps
        assert(steps(12) == 9);

        // Large number of even and odd steps
        assert(steps(1000000) == 152);

        // Zero is an error
        assertThrown(steps(0));

        // Negative value is an error
        assertThrown(steps(-15));
    }
}
