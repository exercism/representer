module collatz_conjecture;


int steps(int n) pure 
{
    if (n < 1)
        throw new Exception("Invalid input value");

    int result;
    while (n > 1)
    {
        if (n & 1)
        {
            n = n * 3 + 1;
        }
        else
        {
            n = n / 2;
        }
        result++;
    }
    return result;
}


unittest
{
    import std.exception : assertThrown;

    const int allTestsEnabled = 1;

    // Zero steps for one
    assert(steps(1) == 0);

    static if (allTestsEnabled)
    {
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
