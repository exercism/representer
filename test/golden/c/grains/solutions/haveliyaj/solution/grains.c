#include "grains.h"

//Wrting power function instead of pow as pow is double format cannot hold sum of all 64 blocks
uint64_t power(uint8_t base, uint8_t exponent)
{
    uint64_t pow_value=1;
    for(int i=0; i<exponent; i++)
    {
        pow_value*=base;
    }

    return pow_value;
}

uint64_t square(uint8_t index)
{
    if(index <=0 || index >=65)
    {
        return 0;
    }
    return power(2,index-1);
}

uint64_t total(void)
{
    uint64_t sum = 0;
    for(int i =0; i < 64; i++)
    {
        sum += power(2,i);
    }
    return sum;
}
