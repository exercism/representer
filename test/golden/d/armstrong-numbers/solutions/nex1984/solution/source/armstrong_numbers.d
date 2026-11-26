module armstrong_numbers;
import std.range;
import std.algorithm;
import std.math;

//reverse digits
ulong[] digits(ulong n) {
    if(n==0) return [0];
    ulong[] ret;
    while(n>0) {
        ret ~= (n%10);
        n/=10;
    }
    return ret;
}

bool isArmstrongNumber(ulong n) {
    auto d = n.digits;
    return d.map!(x=>pow(x,d.length)).sum == n;
}

unittest
{
    immutable int allTestsEnabled = 0;

    // Zero is an Armstrong number
    assert(isArmstrongNumber(0));

    static if (allTestsEnabled)
    {
        // Single digit numbers are Armstrong numbers
        assert(isArmstrongNumber(5),"5");

        // There are no 2 digit Armstrong numbers
        assert(!isArmstrongNumber(10),"10");

        // Three digit number that is an Armstrong number
        assert(isArmstrongNumber(153),"153");

        // Three digit number that is not an Armstrong number
        assert(!isArmstrongNumber(100),"100");

        // Four digit number that is an Armstrong number
        assert(isArmstrongNumber(9474),"9474");

        // Four digit number that is not an Armstrong number
        assert(!isArmstrongNumber(9475),"9475");

        // Seven digit number that is an Armstrong number
        assert(isArmstrongNumber(9926315));

        // Seven digit number that is not an Armstrong number
        assert(!isArmstrongNumber(9926314));
    }
}
