#include <math.h>
#include "grains.h"

uint64_t square(uint8_t index)
{
    uint64_t num = (uint64_t) pow((double) 2, (double) index - 1);

    return num;
}


uint64_t total(void)
{
    uint64_t sum = 0;

    for (int i = 1; i <= 64; i++) {
        sum += square((uint8_t) i);
    }

    return sum;

}
