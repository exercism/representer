#include "space_age.h"

namespace space_age {
    space_age::space_age(long long num) 
    {
        ageInSeconds = num;
        setEarthYear();
    }
    long long space_age::seconds() const { return ageInSeconds; }
    double space_age::on_mercury() const { return ageOnEarth / 0.2408467; }
    double space_age::on_venus() const { return ageOnEarth / 0.61519726; }
    double space_age::on_earth() const{ return ageOnEarth;}
    double space_age::on_mars() const { return ageOnEarth / 1.8808158; }
    double space_age::on_jupiter() const {  return ageOnEarth / 11.862615; }
    double space_age::on_saturn() const { return ageOnEarth / 29.447498; }
    double space_age::on_uranus() const { return ageOnEarth / 84.016846; }
    double space_age::on_neptune() const { return ageOnEarth / 164.79132; }
    void space_age::setEarthYear() { ageOnEarth = (double) ageInSeconds / secondsPerEarthYear; }

}  // namespace space_age
