#if !defined(SPACE_AGE_H)
#define SPACE_AGE_H

#define const_t constexpr static

namespace space_age {
    const double EARTH_YR_SECONDS = 31557600;

    struct EARTH_YR_OF{
        const_t double MERCURY = .2408467;
        const_t double VENUS = .61519726;
        const_t double MARS = 1.8808158;
        const_t double JUPITER = 11.862615;
        const_t double SATURN = 29.447498;
        const_t double URANUS = 84.016846;
        const_t double NEPTUNE = 164.79132;
    };

    class space_age{
        private:
        double age_in_seconds;

        public:
        explicit space_age(double seconds) {
            age_in_seconds = seconds;
        };
        double seconds() const {
            return age_in_seconds;
        }
        double on_earth() const {
            return age_in_seconds / EARTH_YR_SECONDS;
        }
        double on_mercury() const {
            return on_earth() / EARTH_YR_OF::MERCURY;
        }
        double on_venus() const {
            return on_earth() / EARTH_YR_OF::VENUS;
        }
        double on_mars() const {
            return on_earth() / EARTH_YR_OF::MARS;
        }
        double on_jupiter() const {
            return on_earth() / EARTH_YR_OF::JUPITER;
        }
        double on_saturn() const {
            return on_earth() / EARTH_YR_OF::SATURN;
        }
        double on_uranus() const {
            return on_earth() / EARTH_YR_OF::URANUS;
        }
        double on_neptune() const {
            return on_earth() / EARTH_YR_OF::NEPTUNE;
        }
    };
}  // namespace space_age

#endif // SPACE_AGE_H