/// See https://exercism.org/tracks/d/exercises/armstrong-numbers
module armstrong_numbers;

import std.math;

/// Compute whether a number is an Armstrong number.
///
/// Params:
///   num = the number to check
///
/// Returns:
///   whether num is an Armstrong number.
///
/// Use clever way to compute the digit length immediately from num.
///
/// Then loop just once to get each digit and use it immediately.
bool isArmstrongNumber(uint num) {
    const auto num_digits = lrint(floor(log10(num) + 1.0));

    auto sum_powers = 0;

    auto remaining = num;
    while (remaining != 0) {
        const auto q = remaining / 10;
        const auto digit = remaining % 10;

        sum_powers += pow(digit, num_digits);

        remaining = q;
    }

    return sum_powers == num;
}

///
unittest
{
    immutable int allTestsEnabled = 1;

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
