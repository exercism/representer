#include "grains.h"

#define NUMBER_OF_SQUARES    64

uint64_t square(uint8_t index) {
    if (index > NUMBER_OF_SQUARES) return 0;
    if(index == 1) return 1;
    return 2*square(index-1);
}
uint64_t total(void) {
    return 2*square(NUMBER_OF_SQUARES)-1;
}