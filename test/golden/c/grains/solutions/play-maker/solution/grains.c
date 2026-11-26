#include "grains.h"

uint64_t power(uint64_t a,uint64_t b)
{
    if(b==0) return 1;
    if(b==1) return a;
    else return a*power(a,b-1);
}

uint64_t square(uint8_t index)
{
    if(index==0) return 0;
    
    return power(2,index-1);
}

uint64_t total(void)
{
    uint64_t sum=0;
    for(int i=0;i<64;i++)
    {
        sum+=square(i+1);
    }
    return sum;
}