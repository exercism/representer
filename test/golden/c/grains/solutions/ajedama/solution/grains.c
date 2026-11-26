#include "grains.h"

uint64_t square(uint8_t index)
{
    uint64_t grains_square = 1;
    if (index == 0)
        return 0;
    else if (index == 1)
        return 1;
    else
        for (int i = 1; i < index; i++)
            grains_square *= 2;
    
    return grains_square;
}

uint64_t total(void)
{
    uint64_t total_grains = 0;
    for (int i = 1; i <= 64; i++)
        total_grains += square(i);
    
    return total_grains;
}