module nth_prime;

uint[] primes;

void sieve() 
{
    // Using random number bigger than the biggest prime I need to find
    bool[200000] isPrime = true;

    for (int p = 2; p * p < 200_000; p++)
    {
        if (isPrime[p] == true)
        {
            for (int i = p * p; i < 200_000; i += p) 
            {
                isPrime[i] = false;
            }
        }
    }

    for (int p = 2; p < 200_000; p++)
    {
        if (isPrime[p]) primes ~= p;
    }
}

uint prime(uint index) 
{
    if (index == 0) throw new Exception("No zeroth prime number");

    if (primes.length == 0) sieve();

    return primes[index -1];
}

unittest
{
    import std.exception : assertThrown;

    immutable int allTestsEnabled = 2;

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
