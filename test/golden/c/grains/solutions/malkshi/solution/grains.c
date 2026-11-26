#include <math.h>
#include "grains.h"
uint64_t square(uint8_t index)
{
    index--;
    if(index == 64)
        return 0;
    if(!index)
        return 1;

    uint64_t amount = 1;
    while(index-- > 0)
        amount = (amount + amount);
    return amount;
}
uint64_t total(void)
{
    return (uint64_t)pow((double)16, (double)16);
}