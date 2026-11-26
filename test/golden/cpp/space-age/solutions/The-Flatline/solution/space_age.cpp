#include "space_age.h"

namespace space_age {

    space_age::space_age(double secs) :age(secs) {}

    double space_age::seconds() const{
        
        return this->age;
    }

    double multiplier(space_age::planets planets){

        switch (planets){

            case space_age::planets::Neptune: return 164.79132;
            case space_age::planets::Uranus: return 84.016846;
            case space_age::planets::Saturn: return 29.447498;
            case space_age::planets::Jupiter: return 11.862615;
            case space_age::planets::Mars: return 1.8808158;
            case space_age::planets::Earth: return 1.0;
            case space_age::planets::Venus: return 0.61519726;
            case space_age::planets::Mercury: return 0.2408467;
            default: return 1.0;
        }
    } 

    double convert_to_planet(long secs, space_age::planets planets){
        return secs / (31557600.0 * multiplier(planets));
    }

    double space_age::on_earth() const{

        return convert_to_planet(this->seconds(), Earth);
    }

    double space_age::on_mercury() const{
        
        return convert_to_planet(this->seconds(), Mercury);
        
    }

    double space_age::on_venus() const{
        
        return convert_to_planet(this->seconds(), Venus);
        
    }

    double space_age::on_mars() const{
        
        return convert_to_planet(this->seconds(), Mars);
        
    }

    double space_age::on_jupiter() const{
        
        return convert_to_planet(this->seconds(), Jupiter);
       
    }

    double space_age::on_saturn() const{
        
        return convert_to_planet(this->seconds(), Saturn);
       
    }

    double space_age::on_uranus() const{
        
        return convert_to_planet(this->seconds(), Uranus);
        
    }

    double space_age::on_neptune() const{
        
        return convert_to_planet(this->seconds(), Neptune);
        
    }


}  // namespace space_age
