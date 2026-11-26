module collatz_conjecture;

int steps(int n) {
    if (n <= 0) {
        throw new Exception("n must be positive");
    }

    int result = 0;

    while (n > 1) {
        n = n % 2 == 0 ? n / 2 : 3*n+1;
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
