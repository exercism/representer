#include "grains.h"
#include <math.h>

uint64_t square(uint8_t index) {
    if (index > 64 || index < 1) {
        return 0;
    }
if (index == 1) {
    return 1;
    }
    return pow(2, index - 1);
}

uint64_t total(void) {
    uint64_t result = 0;
    for (int i = 1; i < 65; i++) {
        result += square(i);
    }

    return result;
}