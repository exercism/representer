#include "grains.h"
#include <math.h>

uint64_t square(uint8_t index){
    return pow(2, index-1);
}
uint64_t total(void){
    uint8_t squares = 64;
    uint64_t total = 0;
    for (int i = 1; i<=squares;i++){
        total += square(i);
    }
    return total;
}