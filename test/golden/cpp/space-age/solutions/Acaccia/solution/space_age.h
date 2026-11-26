#if !defined(SPACE_AGE_H)
#define SPACE_AGE_H

namespace space_age {
class space_age {
 public:
  explicit constexpr space_age(unsigned long seconds) : _seconds(seconds) {}

  constexpr unsigned long seconds() const { return _seconds; }

  constexpr double on_earth() const { return _seconds / 31557600.0; }

  constexpr double on_mercury() const { return on_earth() / 0.2408467; }
  constexpr double on_venus() const { return on_earth() / 0.61519726; }
  constexpr double on_mars() const { return on_earth() / 1.8808158; }
  constexpr double on_jupiter() const { return on_earth() / 11.862615; }
  constexpr double on_saturn() const { return on_earth() / 29.447498; }
  constexpr double on_uranus() const { return on_earth() / 84.016846; }
  constexpr double on_neptune() const { return on_earth() / 164.79132; }

 private:
  unsigned long _seconds;
};
}  // namespace space_age

#endif  // SPACE_AGE_H