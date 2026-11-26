module collatz_conjecture;

int steps(int n) pure {
    import std.exception : enforce;
        enforce(n > 0, "Error!");
        int iter(int s, int num) pure {
	    return num == 1 ? s : iter(s + 1, num % 2 == 0 ? num / 2 : num * 3 + 1);
    }
    return iter(0, n);
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
