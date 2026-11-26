module nth_prime;

uint prime(in uint n)
{
    if (!n)
    {
        throw new Exception("Start counting at one, comedian!");
    }

    uint primes;
    uint number;
    while (primes < n)
    {
        ++number;
        if (isPrime(number))
        {
            ++primes;
        }
    }
    import std.stdio;
    writeln(number);
    return number;
}

bool isPrime(in uint n)
{
    if (n < 2)
    {
        return false;
    }
    for (uint i = 2; i < n; ++i)
    {
        if (!(n%i))
        {
            return false;
        }
    }
    return true;
}

unittest
{
    import std.exception : assertThrown;

    immutable int allTestsEnabled = 0;

    // First prime
    assert(prime(1) == 2);

    static if (allTestsEnabled)
    {
        // Second prime
        assert(prime(2) == 3);

        // Sixth prime
        assert(prime(6) == 13);

        // Big prime
        assert(prime(10_001) == 10_4743);

        // There is no zeroth prime
        assertThrown(prime(0));
    }

}
