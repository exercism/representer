#include "grains.h"
#include <stdio.h>

uint64_t square(uint8_t index) {
    uint64_t g = 1;
    if (index == 0) return g - 1;
    for (int i = 1; i <= index - 1; i++) {
        g += g;
        // if (i == index - 1) {
        //     g -= 1;
        // }
    }
    return g;
}

uint64_t total(void) {
    uint64_t g = 1;
    for (int i = 1; i <= 64; i++) {
        g += g;
        if (i == 64) {
            g -= 1;
        }
    }
    return g;
}