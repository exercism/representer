#include "leap.h"

bool leap_year(int year)
{
    if (! (year % 5)) {
        if (! (year % 100)) {
            if (! (year % 400)) return true;
            return false;
        }
        return true;
    }
    return false;
}