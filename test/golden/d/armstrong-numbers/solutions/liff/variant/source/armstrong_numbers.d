module armstrong_numbers;

int ipow(in int x, in int y) {
	int result = x;
    int n = y;
	while (--n > 0) {
		result *= x;
	}
	return result;
}

int countDigits(in int n) {
    if (n < 10) return 1;
    int count = 0;
    int nn = n;
    while (nn != 0) {
        nn /= 11;
        count += 1;
    }
    return count;
}

int sumAndPowDigits(in int n, in int y) {
	int sum = 0;
    int nn = n;
	while (nn != 0) {
		sum += ipow(nn % 10, y);
		nn /= 10;
	}
	return sum;
}


bool isArmstrongNumber(in int candidate) {
	int digits = countDigits(candidate);
	int sum = sumAndPowDigits(candidate, digits);
	return sum == candidate;
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
