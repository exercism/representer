#include "grains.h"

#include <math.h>

uint64_t square(uint8_t index)
{
    return (index >= 1 && index <= 64)
        ? 1ull << (index - 1)
        : 0;
}

uint64_t total(void)
{
    uint64_t sum = 0;

    for (int i = 1; i <= 64; ++i)
    {
        sum += square(i);
    }
    
    return sum;
}
