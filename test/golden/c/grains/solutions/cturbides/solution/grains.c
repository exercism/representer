#include "grains.h"

uint64_t square(uint8_t index) {
    if (index > 64 || index < 1) {
        return 0;
    }

    return (uint64_t)1 << (index - 1); // 2^(index - 1)
}

uint64_t total(void) {
    return -1;
    /*
        uint64_t has a range of 0 -> 2^64 - 1
        which is equal to 2^0 + 2^1 + ... + 2^63
    */
}
