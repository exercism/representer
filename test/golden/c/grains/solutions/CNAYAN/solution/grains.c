#include "grains.h"
#include<math.h>
uint64_t square(uint8_t index){
    if(index>=1 && index<=64)
        return pow(2,index-1);
    return 0;
}
uint64_t total(void){
    uint64_t res=0,i;
    for(i=1;i<=64;i++){
        res+=square(i);
    }
    return res;
}