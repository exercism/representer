#include "space_age.h"

namespace space_age {

        const double mercury_earth_years = 0.2408467;
        const double venus_earth_years = 0.61519726;
        const double earth_years = 1.0;
        const double mars_earth_years = 1.8808158;
        const double jupiter_earth_years = 11.862615;
        const double saturn_earth_years = 29.447498;
        const double uranus_earth_years = 84.016846;
        const double neptune_earth_years = 164.79132;
        const double earth_days = 365.25;
        const double earth_seconds = earth_days * 24 * 60 * 60;
        const double mercury_earth_seconds = earth_seconds * mercury_earth_years;
        const double venus_earth_seconds = earth_seconds * venus_earth_years;
        const double mars_earth_seconds = earth_seconds * mars_earth_years;
        const double jupiter_earth_seconds = earth_seconds * jupiter_earth_years;
        const double saturn_earth_seconds = earth_seconds * saturn_earth_years;
        const double uranus_earth_seconds = earth_seconds * uranus_earth_years;
        const double neptune_earth_seconds = earth_seconds * neptune_earth_years;

        double space_age::space_age::seconds() const{ return this->age_sec;}
        double space_age::space_age::on_earth() const{ return this->seconds()/earth_seconds;}
        double space_age::space_age::on_mercury() const { return this->seconds()/mercury_earth_seconds;}
        double space_age::space_age::on_venus() const { return this->seconds()/venus_earth_seconds;}
        double space_age::space_age::on_mars() const { return this->seconds()/mars_earth_seconds;}
        double space_age::space_age::on_jupiter() const {return this->seconds()/jupiter_earth_seconds;}
        double space_age::space_age::on_saturn() const { return this->seconds()/saturn_earth_seconds; }
        double space_age::space_age::on_uranus() const { return this->seconds()/uranus_earth_seconds;}
        double space_age::space_age::on_neptune() const { return this->seconds()/neptune_earth_seconds; }
}  // namespace space_age
