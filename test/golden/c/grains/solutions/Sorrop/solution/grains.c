#include "grains.h"

uint64_t square(uint8_t index) {
    
    return index <= 0 || index > 64 ? 0 : 1ull << (index-1); 
}

uint64_t total(void) {
    return square(63) + ~square(63);
}