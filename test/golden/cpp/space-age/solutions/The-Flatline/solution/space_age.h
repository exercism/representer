#if !defined(SPACE_AGE_H)
#define SPACE_AGE_H
#include <iostream>
#include <string>
using namespace std;

namespace space_age {

class space_age{

private:

    double age;

public:
    
    space_age(double secs);
    double seconds() const;
    double on_earth() const;
    double on_mercury() const;
    double on_venus() const;
    double on_mars() const;
    double on_jupiter() const;
    double on_saturn() const;
    double on_uranus() const;
    double on_neptune() const;

    enum planets{Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune};
    
};
}  // namespace space_age

#endif // SPACE_AGE_H