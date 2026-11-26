#include "eliuds_eggs.h"

int egg_count(unsigned int input) {
    unsigned int ret = 0;
    for (unsigned int i = 0; i <= 32; i++) {
        if (input & 1) {
            ret++;
        }
        input >>= 1;
    }
    return ret;
}