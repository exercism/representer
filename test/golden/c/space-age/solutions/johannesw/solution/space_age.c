#include "space_age.h"

float seconds_to_earth_years(float seconds)
{
    return seconds / EARTH_YEAR_IN_SECONDS;
}

float age(planet_t planet, int64_t seconds)
{
    switch (planet)
    {
        case MERCURY:
        {
             return seconds_to_earth_years(seconds) / MERCURY_ORBIT_IN_EARTH_YEARS;
        }
        case VENUS:
        {
            return seconds_to_earth_years(seconds) / VENUS_ORBIT_IN_EARTH_YEARS;
        }
        case EARTH:
        {
            return seconds_to_earth_years(seconds);
        }
        case MARS:
        {
            return seconds_to_earth_years(seconds) / MARS_ORBIT_IN_EARTH_YEARS;
        }
        case JUPITER:
        {
            return seconds_to_earth_years(seconds) / JUPITER_ORBIT_IN_EARTH_YEARS;
        }
        case SATURN:
        {
            return seconds_to_earth_years(seconds) / SATURN_ORBIT_IN_EARTH_YEARS;
        }
        case URANUS:
        {
            return seconds_to_earth_years(seconds) / URANUS_ORBIT_IN_EARTH_YEARS;
        }
        case NEPTUNE:
        {
            return seconds_to_earth_years(seconds) / NEPTUNE_ORBIT_IN_EARTH_YEARS;
        }
        default: return -1;
    }
}
