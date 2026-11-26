#include "grains.h"

long unsigned int square(unsigned char n)
{
    if (n < 1 || n > 64) return 0;
    if (n == 1) return 1;
    return 2 * square(n-1);
}

long unsigned int total()
{
    return 2 * square(64) - 1;
}