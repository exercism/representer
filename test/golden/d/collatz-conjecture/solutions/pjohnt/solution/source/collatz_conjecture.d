module collatz_conjecture;

int steps(int n)
{
  import std.exception;
  enforce(n > 0);
  int count = 0;
  for (; n > 1; count++)
    n = n % 2 ? 3*n + 1 : n / 2;
  return count;
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
