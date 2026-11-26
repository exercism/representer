#include "grains.h"
uint64_t square(uint8_t index) {
    long int res = 1;
    while (--index > 0)
        res *= 2l;
    return res;
}
uint64_t total(void) {
    long int sum = 0;
    long int sq = 1;
    int i = 1;
    while (i++ <= 64) {
        sum += sq;
        sq *= 2;
    }
    return sum;
}