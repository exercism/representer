#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include "darts.h"

#define RADII_COUNT 3

const float RADII[RADII_COUNT] = {
    1.0F, 5.0F, 10.0F,
};

const Range RANGES[RADII_COUNT + 1] = {
    INNER_CIRCLE, MIDDLE_CIRCLE, OUTER_CIRCLE, OUTSIDE
};

float distance_from_center(coordinate_t landing_position) {
    return hypotf(landing_position.x, landing_position.y);
}

uint8_t score(coordinate_t landing_position) {
    float distance = distance_from_center(landing_position);
    int i = 0;
    while (i < RADII_COUNT && distance > RADII[i]) {
        i++;
    }
    return RANGES[i];
}
