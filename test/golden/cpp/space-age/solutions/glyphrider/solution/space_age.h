#if !defined(SPACE_AGE_H)
#define SPACE_AGE_H

#define ON(planet) double on_##planet() const { return _seconds / planet; }

namespace space_age {
  class space_age {
    static constexpr double earth = 31557600;
    static constexpr double mercury = 0.2408467 * earth;
    static constexpr double venus = 0.61519726 * earth;
    static constexpr double mars = 1.8808158 * earth;
    static constexpr double jupiter = 11.862615 * earth;
    static constexpr double saturn = 29.447498 * earth;
    static constexpr double uranus = 84.016846 * earth;
    static constexpr double neptune = 164.79132 * earth;
    long _seconds;
  public:
    space_age(long seconds);

    long seconds() const;

    ON(mercury);
    ON(venus);
    ON(earth);
    ON(mars);
    ON(jupiter);
    ON(saturn);
    ON(uranus);
    ON(neptune);
  };

}  // namespace space_age

#endif // SPACE_AGE_H
