#include "grains.h"
// #include <math.h>

#define NUMBER_OF_SQUARES (64)

uint64_t square(uint8_t index)
{
    uint64_t result = 1;

    while (index - 1 != 0)
    {
        index--;
        result *= 2;
    }

    return result;
    // return pow(2, index - 1);
}

uint64_t total(void)
{
    uint64_t sum = 0;

    for (uint8_t i = 1; i <= NUMBER_OF_SQUARES; i++)
        sum += square(i);

    return sum;
}