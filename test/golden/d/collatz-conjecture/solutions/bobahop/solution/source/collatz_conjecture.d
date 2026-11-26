module collatz_conjecture;

import std.exception : enforce;

@safe pure int steps (int num) {

    enforce(num > 0, "number must be greater than zero");

    int step_count = 0;
    for (; num != 1; step_count++)
        num = num & 1 ? (num * 3) + 1: num >> 1;
    return step_count;
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
