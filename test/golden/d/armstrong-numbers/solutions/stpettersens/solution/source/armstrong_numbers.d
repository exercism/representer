module armstrong_numbers;

import std.conv;
import std.math;

bool isArmstrongNumber(ulong number) {
	immutable ulong ASCII = 48;
	bool armstrong = false;
	string n = to!string(number);
	ulong sum = 0;
	for (int i = 0; i < n.length; i++) {
		ulong x = to!ulong(n[i]) - ASCII;
		ulong y = pow(x, n.length);
		sum += y;
	}

	if (number == sum) armstrong = true;

	return armstrong;
}

unittest
{
    immutable bool allTestsEnabled = true;

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
