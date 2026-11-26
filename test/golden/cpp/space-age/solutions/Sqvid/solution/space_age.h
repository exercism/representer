#if !defined(SPACE_AGE_H)
#define SPACE_AGE_H

namespace space_age {
	const double mercury_year = 0.2408467;
	const double venus_year = 0.61519726;
	const double mars_year = 1.8808158;
	const double jupiter_year = 11.862615;
	const double saturn_year = 29.447498;
	const double uranus_year = 84.016846;
	const double neptune_year = 164.79132;

	// 60 sec/min * 60 min/hour * 24 hours/day * 365.25 days/year;
	const double sec_per_earth_year = 60 * 60 * 24 * 365.25;

	class space_age {
		public:
			space_age() = default;
			// Allow implicit construction.
			space_age(const double age_seconds) : seconds_(age_seconds) {};

			// Accessor
			double seconds() const { return seconds_; }

			// Return age in planetary years.
			double on_earth() const { return seconds_ / sec_per_earth_year; };

			double on_mercury() const { return on_earth() / mercury_year; }
			double on_venus() const { return on_earth() / venus_year; }
			double on_mars() const { return on_earth() / mars_year; }
			double on_jupiter() const { return on_earth() / jupiter_year; }
			double on_saturn() const { return on_earth() / saturn_year; }
			double on_uranus() const { return on_earth() / uranus_year; }
			double on_neptune() const { return on_earth() / neptune_year; }

		private:
			double seconds_;
	};

}  // namespace space_age

#endif // SPACE_AGE_H
