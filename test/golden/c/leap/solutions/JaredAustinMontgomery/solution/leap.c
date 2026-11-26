#include "leap.h"

// Returns true if [year] is a leap year.
bool leap_year(int year)
{
    // If year is divisible by 4, then it may be a leap year.
    if (year % 4 == 0)
    {
        if (year % 100 == 0)
        {
            // If a year is divisible by 4 and 100, then it is only a leap year
            // if it is also divisible by 400.
            return year % 400 == 0;
        }

        return true;
    }

    return false;
}