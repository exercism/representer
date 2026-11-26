#include "grains.h"

uint64_t square(uint8_t index) {
    if (index == 0) 
        return 0;
    uint64_t result = 1; 
    for (uint8_t i = 1; i < index; i++) 
        result *= 2; 

    return result;
}

uint64_t total(void) {
    uint64_t sum = 0;
    for (uint8_t i = 0; i < 64; i++) {
        if (i == 0) {
            sum+= 1;
            continue;
        } else {
            sum += square(i + 1);
        }
    }        
    return sum;
}
