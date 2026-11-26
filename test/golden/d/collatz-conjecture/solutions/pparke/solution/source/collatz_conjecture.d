module collatz_conjecture;

pure int collatz(immutable int x) {
    if (x % 2 == 0) {
        return x / 2;
    }
    return x * 3 + 1;
}

int steps(immutable int n) {
    import std.exception : enforce;

    enforce(n > 0, "n must be a positive, non-zero integer.");

    if (n == 1) return 0;
    
    int count = 0;
    int r = n;
    while (r != 1) {
        r = collatz(r);
        count += 1;
    }

    return count;
}

unittest
{
    import std.exception : assertThrown;

    const int allTestsEnabled = 1;

    // Zero steps for one
    assert(steps(1) == 0);

    assert(steps(2) == 1);

    assert(steps(3) == 7);

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
