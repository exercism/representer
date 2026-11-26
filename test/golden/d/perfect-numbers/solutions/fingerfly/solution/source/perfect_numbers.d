module perfect_numbers;

import std.algorithm;
import std.range;
import std.math;


enum Classification
{
    DEFICIENT,
    PERFECT,
    ABUNDANT
}

int[] factors(int n) {
    int[] res;
    int upper_bound = 1 + cast(int) (n*1.0).sqrt;
    foreach(k; 1.. upper_bound) {
        if ( n % k == 0) {
            res ~= k;
            auto q = n / k;
            if ( k != q) { res ~= q; }
        }
    }
    return res;
}

int sum(int[] xs ) {
    return reduce!( (acc, k) => acc + k ) (0, xs);
}

Classification classify(int n) {
    if (n <= 0) { throw new Exception("not a natural number");}

    auto sum =  factors(n).sum - n;
    if (sum == n) {return Classification.PERFECT; }
    else if ( sum < n ) { return Classification.DEFICIENT; }
    else { return Classification.ABUNDANT; }

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
