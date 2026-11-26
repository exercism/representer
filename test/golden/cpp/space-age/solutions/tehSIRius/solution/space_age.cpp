#include "space_age.h"

namespace space_age
{
    long space_age::seconds() const
    {
        return source;
    }

    double space_age::on_mercury() const
    {
        return (double)source / (double)31557600 / 0.2408467;
    }

    double space_age::on_venus() const
    {
        return (double)source / (double)31557600 / 0.61519726;
    }

    double space_age::on_earth() const
    {
        return (double)source / (double)31557600;
    }

    double space_age::on_mars() const
    {
        return (double)source / (double)31557600 / 1.8808158;
    }

    double space_age::on_jupiter() const
    {
        return (double)source / (double)31557600 / 11.862615;
    }

    double space_age::on_saturn() const
    {
        return (double)source / (double)31557600 / 29.447498;
    }

    double space_age::on_uranus() const
    {
        return (double)source / (double)31557600 / 84.016846;
    }

    double space_age::on_neptune() const
    {
        return (double)source / (double)31557600 / 164.79132;
    }
} // namespace space_age
