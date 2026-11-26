module armstrong_numbers;

bool isArmstrongNumber(int n) {
    if (n < 0) {
        return false;
    }
    int len = 0;
    int acc = n;
    do {
        acc /= 10;
        len++;
    } while(acc != 0);
    int sum = 0;
    acc = n;
    while(acc != 0) {
        int digit = acc % 10;
        int pow = len;
        int digitToPowerLen = 1;
        while(pow > 0) {
            digitToPowerLen *= digit;
            pow--;
        }
        sum += digitToPowerLen;
        acc /= 10;
    }
    return n == sum;
}

unittest
{
    immutable int allTestsEnabled = 0;

    // Zero is an Armstrong number
    assert(isArmstrongNumber(0));

    static if (allTestsEnabled)
    {
        // Single digit numbers are Armstrong numbers
        assert(isArmstrongNumber(5));

        // There are no 2 digit Armstrong numbers
        assert(!isArmstrongNumber(10));

        // Three digit number that is an Armstrong number
        assert(isArmstrongNumber(153));

        // Three digit number that is not an Armstrong number
        assert(!isArmstrongNumber(100));

        // Four digit number that is an Armstrong number
        assert(isArmstrongNumber(9474));

        // Four digit number that is not an Armstrong number
        assert(!isArmstrongNumber(9475));

        // Seven digit number that is an Armstrong number
        assert(isArmstrongNumber(9926315));

        // Seven digit number that is not an Armstrong number
        assert(!isArmstrongNumber(9926314));
    }
}
