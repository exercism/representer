module perfect_numbers;

//(1+2+4)*1+(1+2)*7 = 28

auto sumOfProperFactors(long n) {
    if(n<=0) { throw new Exception(""); }
    if(n==1) { return 0; }
    if(n%2==0) {
        long f = 1;
        long m;
        do {
            m+=f;
            f*=2;
            n/=2;
        } while(n%2==0);
        return (m+f)*sumOfProperFactors(n)+m*n;
    }
    for(long d=3; d*d <= n; d+=2) {
      if(n%d==0) {
        long f = 1;
        long m;
        do {
            m+=f;
            f*=d;
            n/=d;
        } while(n%2==0);
        return (m+f)*sumOfProperFactors(n)+m*n;
        }
    }
    return 1;
}

auto classify(long n) {
    long sum = sumOfProperFactors(n);
    if(sum < n) { return Classification.DEFICIENT; }
    if(sum == n) { return Classification.PERFECT; }
    return Classification.ABUNDANT;
}

enum Classification
{
    DEFICIENT,
    PERFECT,
    ABUNDANT
}

unittest
{
    import std.exception : assertThrown;

    immutable int allTestsEnabled = 0;

    // Perfect numbers

    // Smallest perfect number is classified correctly
    assert(classify(6) == Classification.PERFECT);

    // Medium perfect number is classified correctly
    assert(classify(28) == Classification.PERFECT);

    // Large perfect number is classified correctly
    assert(classify(33_550_336) == Classification.PERFECT);

    static if (allTestsEnabled)
    {
        // Abundant numbers

        // Smallest abundant number is classified correctly
        assert(classify(12) == Classification.ABUNDANT);

        // Medium abundant number is classified correctly
        assert(classify(30) == Classification.ABUNDANT);

        // Large abundant number is classified correctly
        assert(classify(33_550_335) == Classification.ABUNDANT);

        // Deficient numbers

        // Smallest prime deficient number is classified correctly
        assert(classify(2) == Classification.DEFICIENT);

        // Smallest non-prime deficient number is classified correctly
        assert(classify(4) == Classification.DEFICIENT);

        // Medium deficient number is classified correctly
        assert(classify(32) == Classification.DEFICIENT);

        // Large deficient number is classified correctly
        assert(classify(33_550_337) == Classification.DEFICIENT);

        // Edge case (no factors other than itself) is classified correctly
        assert(classify(1) == Classification.DEFICIENT);

        // Invalid inputs

        // Zero is rejected (not a natural number)
        assertThrown(classify(0));

        // Negative integer is rejected (not a natural number)
        assertThrown(classify(-1));
    }

}
