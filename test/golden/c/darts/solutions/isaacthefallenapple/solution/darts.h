#ifndef DARTS_H
#define DARTS_H

typedef enum {
    OUTSIDE = 0,
    OUTER_CIRCLE = 1,
    MIDDLE_CIRCLE = 5,
    INNER_CIRCLE = 10,
} Range;

typedef struct {
    float x;
    float y;
} coordinate_t;

float distance_from_center(coordinate_t landing_position);

Range range_from_distance(float distance);

uint8_t score(coordinate_t landing_position);

#endif
