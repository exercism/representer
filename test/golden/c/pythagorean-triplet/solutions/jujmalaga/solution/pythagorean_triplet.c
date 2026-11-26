#include "pythagorean_triplet.h"
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#define MIN_TRIPLET_SUM 12

/* add a triplet ordered  a < b < c and unique */
static triplets_t *add_unique_triplet(triplets_t *ts, uint16_t a, uint16_t b, uint16_t c)
{
    if (b < a) {
        uint16_t tmp = b;
        b = a;
        a = tmp;
    }
    if (ts->count) {
        for (uint16_t i = 0; i < ts->count; ++i) {
            if (ts->triplets[i].a == a) {
                return ts;
            }
        }
    }
    if (!ts->count) {
        ts->triplets = calloc(1, sizeof(triplet_t));
    } else {
        ts->triplets = realloc(ts->triplets, sizeof(triplet_t) * (ts->count + 1));
    }
    ts->triplets[ts->count].a = a;
    ts->triplets[ts->count].b = b;
    ts->triplets[ts->count].c = c;
    ts->count++;
    return ts;
}

triplets_t *triplets_with_sum(uint16_t sum)
{
    triplets_t *result = calloc(1, sizeof(triplets_t));
    if (sum < MIN_TRIPLET_SUM || sum % 2) {
        return result;
    }
    uint32_t d = sum * sum / 2;
    for (uint16_t i = (sum / 2) + 1; i < sum; ++i) {
        if (!(d % i)) {
            uint16_t a = sum - i;
            uint16_t b = sum - ((sum * sum) / (2 * i));
            uint16_t c = sum - a - b;
            add_unique_triplet(result, a, b, c);
        }
    }
    return result;
}

void free_triplets(triplets_t *triplets)
{
    if (triplets) {
        if (triplets->triplets) {
            free(triplets->triplets);
            triplets->triplets = NULL;
        }
        free(triplets);
        triplets = NULL;
    }
}
