#include <math.h>
#include "grains.h"

uint64_t square(uint8_t index)
{
    if(index > 0 && index < 65)
        return pow(2, index-1);
    return 0;
}

uint64_t total(void)
{
    int total = 0;
    for (int i = 1; i < 65; i++)
    {
        total += square(i);
    }
    
    return total;
}
