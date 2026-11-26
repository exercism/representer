#include "grains.h"

uint64_t square(uint8_t index) {
    int arg = (int) index - 1;
    double val = pow(2, (double) arg);
    return (uint64_t) val;
}

uint64_t total(void) {
    uint64_t tot = 0;

    for (int i=1; i<=64; i++) {
        tot += square((uint64_t) i);
    }

    return tot;
}