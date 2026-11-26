module prime_factors;

pure int[] factors(immutable long value)
{
    // implement this function
    int[] fs;
    long v = value;
    while (v % 2 == 0) {
        fs ~= 2;
        v /= 2;
    }
    int p = 3;
    while (p * p <= v) {
        while (v % p == 0) {
            fs ~= p;
            v /= p;
        }
        p += 2;
    }
    if (v != 1) {
        fs ~= cast(int)(v);
    }
    return fs;
}

unittest
{
    immutable int allTestsEnabled = 1;

    // No factors
    assert(factors(1) == []);

    static if (allTestsEnabled)
    {
        // Prime number
        assert(factors(2) == [2]);

        // Square of a prime
        assert(factors(9) == [3, 3]);

        // Cube of a prime
        assert(factors(8) == [2, 2, 2]);

        // Product of primes and non-primes
        assert(factors(12) == [2, 2, 3]);

        // Product of primes
        assert(factors(901_255) == [5, 17, 23, 461]);

        // Factors include a large prime
        assert(factors(93_819_012_551) == [11, 9539, 894_119]);
    }
}
