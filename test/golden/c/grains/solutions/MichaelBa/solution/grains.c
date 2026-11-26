#include "grains.h"
#include <math.h>

uint64_t square(uint8_t index)
{
    uint64_t sq = 1;
    if(0 == index)
    {
        sq = 0;
    }
    else
    {
        sq = pow(2,(index-1));
    }
    return sq;
}
uint64_t total(void)
{
    uint64_t sum = 0;
    for(int i = 0; i < 65; i++)
    {
        sum += square(i);
    }
    return sum;
}