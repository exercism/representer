module nth_prime;

extern (C) ulong
prime (uint num)
in {
	if (num < 1)
		throw new Exception("Invalid argument value");
}
do {
	import core.stdc.stdlib: malloc, free;
	import core.stdc.math:   log, ceil;

	/* Treat the first 6 primes separately */
	switch (num) {
		enum smallPrimes = [2, 3, 5, 7, 11, 13];
		case 1: .. case 6:
			return smallPrimes[num - 1];
		default: break;
	}

	size_t upperBound;
	{
		immutable double dup = num;
		upperBound = cast(size_t)ceil(num * (dup.log + dup.log.log));
	}

	bool *seive = cast(bool*)malloc(upperBound);

	if (seive == null)
		throw new Exception("Could not allocate memory");

	scope(exit) free(seive);


	seive[0] = seive[1] = 1;

	-- num;
	/* Mark all the even numbers separately */
	for (uint i = 4; i < upperBound; i += 2)
		seive[i] = 1;


	/* Go till sqrt(upperBound) when searching for primes
	   that will divide other numbers
	   **that have not been marked yet**
	   in the [1, upperBound) range */

	ulong i;
	for (i = 3; i * i < upperBound; i += 2)
		if (!seive[i]) {
			if (-- num == 0) return i;
			/* Advance with 2 * i because we already marked
			   the even numbers */

			for (ulong j = i * i; j < upperBound; j += i << 1)
				seive[j] = 1;
		}

	/* All the composite numbers have been marked,
	   just search till we find our target */

	for (; i < upperBound; i += 2)
		if ((num -= !seive[i]) == 0)
			return i;


	assert(0, "Asked to find a number that's bigger than MAX_NUMBER");
}


unittest
{
    import std.exception : assertThrown;

    immutable int allTestsEnabled = 1;

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
