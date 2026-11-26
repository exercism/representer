module nth_prime;

import std.math : sqrt;
import std.conv : to;

private ulong[] primes = [
    2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41,
    43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97
];

bool isPrime(ulong num)
{
    foreach (ulong prime; primes)
    {
        if (prime > sqrt(num.to!float))
            break;

        if (num % prime == 0)
            return false;
    }

    return true;
}

void extendPrimes(int n)
{
    auto oldLength = primes.length;
    primes.length = n;

    for (auto i = oldLength; i < n; i++)
    {
        for (ulong numToTest = primes[i - 1] + 1; ; numToTest++)
        {
            if (numToTest.isPrime)
            {
                primes[i] = numToTest;
                break;
            }
        }
    }
}

ulong prime(int n)
{
    if (n <= 0)
        throw new Exception("Wrong index");

    if (primes.length >= n)
        return primes[n - 1];

    extendPrimes(n);

    return primes[n - 1];
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
