#include "grains.h"
#include <stdio.h>
#include <math.h>
#include <stdint.h>

uint64_t square(uint8_t index)
{
    if(index==0)
        return 0;
    else
        return pow(2,index-1);
}
uint64_t total(void)
{
    uint64_t sum=0,a;
    int i;
    for(i=0;i<=63;i++)
    {
        a=pow(2,i);
        sum=sum+a;
    }
return sum;
}
