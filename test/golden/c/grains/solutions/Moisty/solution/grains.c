#include "grains.h"

uint64_t power(uint64_t base, uint64_t exp) {
    uint64_t sum = 1;
    for (uint64_t i = 0; i < exp; i++) {
        sum *= base;
    }
    return sum;
}
uint64_t square(uint8_t index) {
    // The first square has a value of 2^0
    // Hence any square will have a value of 2^index-1
    if (index <= 0 || index > 64) return 0;
    return power(2, index - 1); 
}
uint64_t total(void) {
    uint64_t grainSum = 0;
    for (uint8_t i = 1; i <= 64; i++) {
        grainSum += square(i);
    }
    return grainSum;
}
