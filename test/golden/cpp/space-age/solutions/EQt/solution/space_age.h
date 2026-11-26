#if !defined(SPACE_AGE_H)
#define SPACE_AGE_H
#include <cstdint>

namespace space_age {

class space_age
{
    int64_t sec;

  public:
    static constexpr double SEC_PER_YEAR = 31557600.0;
    static constexpr double EARTH_TO_MERCURY = 0.2408467;
    static constexpr double EARTH_TO_VENUS = 0.61519726;
    static constexpr double EARTH_TO_MARS = 1.8808158;
    static constexpr double EARTH_TO_JUPITER = 11.862615;
    static constexpr double EARTH_TO_SATURN = 29.447498;
    static constexpr double EARTH_TO_URANUS = 84.016846;
    static constexpr double EARTH_TO_NEPTUNE = 164.79132;

    space_age(int64_t sec) : sec(sec) {}
    int64_t seconds() const { return sec; }
    double on_earth() const { return double(sec) / SEC_PER_YEAR; }
    double on_mercury() const { return on_earth() / EARTH_TO_MERCURY; }
    double on_venus() const { return on_earth() / EARTH_TO_VENUS; }
    double on_mars() const { return on_earth() / EARTH_TO_MARS; }
    double on_jupiter() const { return on_earth() / EARTH_TO_JUPITER; }
    double on_saturn() const { return on_earth() / EARTH_TO_SATURN; }
    double on_uranus() const { return on_earth() / EARTH_TO_URANUS; }
    double on_neptune() const { return on_earth() / EARTH_TO_NEPTUNE; }
};

} // namespace space_age

#endif // SPACE_AGE_H
