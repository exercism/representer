#include "space_age.h"

namespace space_age {

    space_age::space_age(long sec){
        scnds = sec;
    }

    long space_age::seconds() const{
        return scnds;
    }

    double space_age::on_mercury() const{
        return scnds / (MERCURY_ORBIT * EARTH_SECONDS);    
    }

    double space_age::on_venus() const{
        return scnds / (VENUS_ORBIT * EARTH_SECONDS);  
    }
    
    double space_age::on_earth() const{
        return scnds / (EARTH_ORBIT * EARTH_SECONDS);
    }

    double space_age::on_mars() const{
        return scnds / (MARS_ORBIT * EARTH_SECONDS);
    }

    double space_age::on_jupiter() const{
        return scnds / (JUPITER_ORBIT * EARTH_SECONDS);
    }

    double space_age::on_saturn() const{
        return scnds / (SATURN_ORBIT * EARTH_SECONDS);   
    }

    double space_age::on_uranus() const{
        return scnds / (URANUS_ORBIT * EARTH_SECONDS);
    }

    double space_age::on_neptune() const{
        return scnds / (NEPTUNE_ORBIT * EARTH_SECONDS);
    }

}  // namespace space_age
