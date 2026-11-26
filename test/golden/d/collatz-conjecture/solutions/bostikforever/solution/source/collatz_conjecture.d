module collatz_conjecture;

auto steps(int n) {
    import std.algorithm : count, until;
    import std.range : recurrence;
    if (n <= 0) {
        throw new Exception("Invalid input");
    }
    assert(n > 0);

    return recurrence!((a,n) => a[n-1]%2 == 0? a[n-1]/2: 3 * a[n-1] + 1)(n).
           until!(a => a == 1).count;
    
}

unittest
{
    import std.exception : assertThrown;

    const int allTestsEnabled = 0;

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
