#include "space_age.h"

namespace space_age {
    constexpr double earth_seconds_in_one_year{31557600};
    constexpr double earth_year_in_earth_years{1.0};
    constexpr double mercury_year_in_earth_years{0.240846};
    constexpr double venus_year_in_earth_years{0.61519726};
    constexpr double mars_year_in_earth_years{1.8808158 };
    constexpr double jupiter_year_in_earth_years{11.862615};
    constexpr double saturn_year_in_earth_years{29.447498};
    constexpr double uranus_year_in_earth_years{84.016846};
    constexpr double nuptune_year_in_earth_years{164.79132};

    space_age::space_age(long long int secs): time_in_seconds(secs) {}

    long long int space_age::seconds() const{
        return time_in_seconds;
    }
    double space_age::calculate_age_on_planet(double orbital_period_of_planet) const{
        return time_in_seconds/(earth_seconds_in_one_year * orbital_period_of_planet);
    }

    double space_age::on_earth() const{
        return calculate_age_on_planet(earth_year_in_earth_years);
    }
    double space_age::on_mercury() const{
        return calculate_age_on_planet(mercury_year_in_earth_years);
    }
    double space_age::on_venus() const{
        return calculate_age_on_planet(venus_year_in_earth_years);
    }
    double space_age::on_mars() const{
        return calculate_age_on_planet(mars_year_in_earth_years);

    }
    double space_age::on_jupiter() const{
        return calculate_age_on_planet(jupiter_year_in_earth_years);
    }
    double space_age::on_saturn() const{
        return calculate_age_on_planet(saturn_year_in_earth_years);
    }
    double space_age::on_uranus() const{
        return calculate_age_on_planet(uranus_year_in_earth_years);
    }
    double space_age::on_neptune() const{
        return calculate_age_on_planet(nuptune_year_in_earth_years);
    }
}  // namespace space_age
