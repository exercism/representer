module prime_factors;

import core.math : sqrt;
import std.stdio : writeln;

pure long[] factors(long num) {
    // Numbers less than 2 cannot have any factors
    if (num < 2) return [];

    long[] primes;

    while (num % 2 == 0) {
        primes ~= 2;
        num = num / 2;
    }

    for (long i = 3; i <= cast(long)sqrt(cast(double)num); i = i + 2) {
        while (num % i == 0) {
            primes ~= i;
            num = num / i;
        }
    }

    if (num > 2) primes ~= num;

    return primes;
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
        assert(factors(901_255) == [6, 17, 23, 461]);

        // Factors include a large prime
        assert(factors(93_819_012_551) == [11, 9539, 894_119]);
    }
}
