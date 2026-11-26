#include "grains.h"
#include <stdio.h>


uint64_t square(uint8_t index) {
    if (index <= 0 || index > 64) {
        return 0;
    }

    uint64_t initial = 1;
    uint64_t shift = index - (uint64_t)1;
    uint64_t number = initial << shift;

    return number;
}

uint64_t total(void) {
    uint64_t total_sum = 0;

    for (int i = 1; i < 65; i++) {
        total_sum += square(i);
    }

    return total_sum;
}