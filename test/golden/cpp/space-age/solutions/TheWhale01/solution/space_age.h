#if !defined(SPACE_AGE_H)
#define SPACE_AGE_H

// #define EXERCISM_RUN_ALL_TESTS

#include <cstddef>

namespace space_age {
	class space_age {
		public:
			space_age(const size_t nb);
			~space_age(void);

			size_t const &seconds(void) const;

			double on_earth(void) const;
			double on_mercury(void) const;
			double on_venus(void) const;
			double on_mars(void) const;
			double on_jupiter(void) const;
			double on_saturn(void) const;
			double on_uranus(void) const;
			double on_neptune(void) const;

		private:
			size_t _seconds;
			size_t const _earth_period = 31557600;
			double const _merucry_period = 0.2408467;
			double const _venus_period = 0.61519726;
			double const _mars_period = 1.8808158;
			double const _jupiter_period = 11.862615;
			double const _saturn_period = 29.447498;
			double const _uranus_period = 84.016846;
			double const _neptune_period = 164.79132;
	};
}  // namespace space_age

#endif // SPACE_AGE_H