#include "space_age.h"

namespace space_age 
{    
    space_age::space_age(long year_second) : year(year_second) {}

    long space_age::seconds() const {
        return year;
    }

    double space_age::on_earth() const{
        return seconds()/31557600.0;
    }

    float space_age::on_mercury() const{
        return calculate(0.2408467);
    }

    float space_age::on_venus() const{
        return calculate(0.61519726);
    }

    float space_age::on_mars() const{
        return calculate(1.8808158);
    }

    float space_age::on_saturn() const{
        return calculate(29.447498);
    }

    float space_age::on_jupiter() const{
        return calculate(11.862615);
    }

    float space_age::on_uranus() const{
        return calculate(84.016846);
    }

    float space_age::on_neptune() const{
        return calculate(164.79132);
    }

    float space_age::calculate(float year_planet) const {
        return on_earth()*(1/year_planet);
    }
    

}  // namespace space_age
