#if !defined(SPACE_AGE_H)
#define SPACE_AGE_H

namespace space_age {

     class space_age{
public:

    space_age(long int a){
        ageSeconds = a;
    }

    float on_mercury() const ;
    float on_venus() const ;
    float on_earth() const ;
    float on_mars() const;
    float on_jupiter() const;
    float on_saturn() const;
    float on_uranus() const;
    float on_neptune() const;

    long int seconds() const{
        return ageSeconds;
    }


private:

    long int ageSeconds;
    float oneYearEarthDays = 365.25;
    float MercuryOrbitalPeriod = 0.2408467;
    float VenusOrbitalPeriod = 0.61519726;
    float EarthOrbitalPeriod = 1.0;
    float MarsOrbitalPeriod = 1.8808158;
    float JupiterOrbitalPeriod = 11.862615;
    float SaturnOrbitalPeriod = 29.447498;
    float UranusOrbitalPeriod = 84.016846;
    float NeptuneOrbitalPeriod = 164.79132;

    int dailySeconds = 86400;
};

}  // namespace space_age

#endif // SPACE_AGE_H