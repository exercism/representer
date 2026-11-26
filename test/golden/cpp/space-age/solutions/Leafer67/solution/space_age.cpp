#include "space_age.h"

namespace space_age 
{

space_age::space_age(long long seconds)
{
    this->_seconds = seconds;
    this->_earth_year = static_cast<double>(seconds) / 31557600.0;
}

space_age::~space_age() {}

long long space_age::seconds() const
{
    return _seconds;
}

double space_age::on_earth() const
{
    return _earth_year;
}

double space_age::on_mercury() const
{
    return _earth_year / 0.2408467;
}

double space_age::on_venus() const
{
    return _earth_year / 0.61519726;
}

double space_age::on_mars() const
{
    return _earth_year / 1.8808158;
}

double space_age::on_jupiter() const
{
    return _earth_year / 11.862615;
}

double space_age::on_saturn() const
{
    return _earth_year / 29.447498;
}

double space_age::on_uranus() const
{
    return _earth_year / 84.016846;
}

double space_age::on_neptune() const
{
    return _earth_year / 164.79132;
}



}  // namespace space_age
