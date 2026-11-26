#pragma once


namespace space_age
{
	class space_age
	{
	public:
		space_age(double seconds) : secs(seconds)
		{
		}
		double seconds() const
		{
			return secs;
		}
		double on_earth() const
		{
			return secs/EARTH_YEAR;
		}
		double on_mercury() const
		{
			return secs/MERCURY_YEAR;
		}
		double on_venus() const
		{
			return secs/VENUS_YEAR;
		}
		double on_mars() const
		{
			return secs/MARS_YEAR;
		}
		double on_jupiter() const
		{
			return secs/JUPITER_YEAR;
		}
		double on_saturn() const
		{
			return secs/SATURN_YEAR;
		}
		double on_uranus() const
		{
			return secs/URANUS_YEAR;
		}
		double on_neptune() const
		{
			return secs/NEPTUNE_YEAR;
		}
	private:
		double secs;
        const double EARTH_YEAR = 31557600.0;
	    const double MARS_YEAR = EARTH_YEAR * 1.8808158;
	    const double JUPITER_YEAR = EARTH_YEAR * 11.862615;
	    const double SATURN_YEAR = EARTH_YEAR * 29.447498;
	    const double URANUS_YEAR = EARTH_YEAR * 84.016846;
	    const double NEPTUNE_YEAR = EARTH_YEAR * 164.79132;
        const double MERCURY_YEAR = EARTH_YEAR * 0.2408467;
	    const double VENUS_YEAR = EARTH_YEAR * 0.61519726;
	};
}  // namespace space_age

