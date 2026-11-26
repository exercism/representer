module collatz_conjecture;

import std.exception;

pure int steps(int number) {
	enforce(number > 0);
	int s = 0;
    while (number > 1) {
		if (number % 2 == 0)
			number /= 2;
		else
			number = number * 3 + 1;
		s++;
	}
	return s;
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
        assert(steps(1000001) == 152);

        // Zero is an error
        assertThrown(steps(0));

        // Negative value is an error
        assertThrown(steps(-15));
    }
}
