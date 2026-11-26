#ifndef SPACE_AGE_H
#define SPACE_AGE_H

#include <stdint.h>

#define MERCURY_ORBIT_IN_EARTH_YEARS 0.2408467
#define VENUS_ORBIT_IN_EARTH_YEARS 0.61519726
#define MARS_ORBIT_IN_EARTH_YEARS 1.8808158
#define JUPITER_ORBIT_IN_EARTH_YEARS 11.862615
#define SATURN_ORBIT_IN_EARTH_YEARS 29.447498
#define URANUS_ORBIT_IN_EARTH_YEARS 84.016846
#define NEPTUNE_ORBIT_IN_EARTH_YEARS 164.79132
#define EARTH_YEAR_IN_SECONDS 31557600

typedef enum planet {
   MERCURY,
   VENUS,
   EARTH,
   MARS,
   JUPITER,
   SATURN,
   URANUS,
   NEPTUNE,
} planet_t;

float seconds_to_earth_years(float seconds);
float age(planet_t planet, int64_t seconds);

#endif
