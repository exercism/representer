#include "grains.h"
#include "math.h"


uint64_t square(uint8_t index)
{        
    if(index>64){return 0;}
    return pow(2,index-1);
}


uint64_t total(void)
{
    uint64_t rice = 0;

    for (int i = 0; i < 64; i++)
    {
        rice += 1ULL << i;
    }

    return rice;
}