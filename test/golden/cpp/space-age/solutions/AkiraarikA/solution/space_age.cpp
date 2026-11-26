#include "space_age.h"
#include <iostream>

 using namespace std;

namespace space_age {

float space_age::on_earth() const {
    
    return (seconds() / ((oneYearEarthDays * EarthOrbitalPeriod) * dailySeconds)) ;

}
float space_age::on_mercury() const {
    
    return (seconds() / ((oneYearEarthDays * MercuryOrbitalPeriod) * dailySeconds)) ;

}
float space_age::on_venus() const {
    
    return (seconds() / ((oneYearEarthDays * VenusOrbitalPeriod) * dailySeconds)) ;

}
float space_age::on_mars() const {
    
    return (seconds() / ((oneYearEarthDays * MarsOrbitalPeriod) * dailySeconds)) ;

}
float space_age::on_jupiter() const {
    
    return (seconds() / ((oneYearEarthDays * JupiterOrbitalPeriod) * dailySeconds)) ;

}
float space_age::on_saturn() const {
    
    return (seconds() / ((oneYearEarthDays * SaturnOrbitalPeriod) * dailySeconds)) ;

}
float space_age::on_uranus() const {
    
    return (seconds() / ((oneYearEarthDays * UranusOrbitalPeriod) * dailySeconds)) ;

}
float space_age::on_neptune() const {
    
    return (seconds() / ((oneYearEarthDays * NeptuneOrbitalPeriod) * dailySeconds)) ;

}

}  // namespace space_age
