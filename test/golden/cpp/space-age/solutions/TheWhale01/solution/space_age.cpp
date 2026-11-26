#include "space_age.h"

namespace space_age {

	space_age::space_age(const size_t nb): _seconds(nb) {}
	space_age::~space_age(void) {}

	size_t const &space_age::seconds(void) const {return (_seconds);}

	double space_age::on_earth(void) const {return (_seconds / (double)_earth_period);}
	double space_age::on_mercury(void) const {return (on_earth() / _merucry_period);}
	double space_age::on_venus(void) const {return (on_earth() / _venus_period);}
	double space_age::on_mars(void) const {return (on_earth() / _mars_period);}
	double space_age::on_jupiter(void) const {return (on_earth() / _jupiter_period);}
	double space_age::on_saturn(void) const {return (on_earth() / _saturn_period);}
	double space_age::on_uranus(void) const {return (on_earth() / _uranus_period);}
	double space_age::on_neptune(void) const {return (on_earth() / _neptune_period);}

}  // namespace space_age
