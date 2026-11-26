#include "grains.h"

uint64_t square(uint8_t index) {
    // https://exercism.org/tracks/c/exercises/grains/dig_deeper
    /*
     * For valid values (1-64 inclusive):
     * - value for square `index` equal to 2^ (n-1)
     * - equivalent to left shifting 1 (index - 1) times.
     * All other index values return zero.
     */
    return (index > 0 && index < 65) ? 1ul << (index - 1) : 0;
    uint64_t count = 1;
    while(--index) {
        count *= 2;
    }
    return count;
}

uint64_t total(void) {
    uint8_t squareIndex = 64;
    uint64_t sum = square(squareIndex);
    return sum * 2ull - 1; // Don't know how this is correct, probably some upsetting maths reasons.
}