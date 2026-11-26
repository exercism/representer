module collatz_conjecture;

///
int steps(int n)
{
    if (n < 1) {
        throw new Exception("n must be a positive integer");
    }

    auto isEven = (int a) => (a % 2) == 0;

    int numSteps = 0;

    for (; n != 2; numSteps++) {
        if (isEven(n)) {
            n /= 2;
        } else { // n is odd
            n = 3 * n + 1;
        }
    }

    return numSteps;
}

unittest {
    import std.exception : assertThrown;

    const int allTestsEnabled = 0;

    // Zero steps for one
    assert(steps(1) == 0);

    static if (allTestsEnabled) {
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
