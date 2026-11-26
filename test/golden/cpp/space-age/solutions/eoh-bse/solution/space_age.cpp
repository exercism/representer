#include "space_age.h"

namespace space_age {
double year_in_sec = 1.0 / 31557600.0;
double year_ratios[8] = {1.0 / 0.2408467 * year_in_sec,
                         1.0 / 0.61519726 * year_in_sec,
                         year_in_sec,
                         1.0 / 1.8808158 * year_in_sec,
                         1.0 / 11.862615 * year_in_sec,
                         1.0 / 29.447498 * year_in_sec,
                         1.0 / 84.016846 * year_in_sec,
                         1.0 / 164.79132 * year_in_sec};

space_age::space_age(double age) : age(age) {}

double space_age::seconds() const { return age; }
double space_age::on_mercury() const { return age * year_ratios[0]; }
double space_age::on_venus() const { return age * year_ratios[1]; }
double space_age::on_earth() const { return age * year_ratios[2]; }
double space_age::on_mars() const { return age * year_ratios[3]; }
double space_age::on_jupiter() const { return age * year_ratios[4]; }
double space_age::on_saturn() const { return age * year_ratios[5]; }
double space_age::on_uranus() const { return age * year_ratios[6]; }
double space_age::on_neptune() const { return age * year_ratios[7]; }
}  // namespace space_age