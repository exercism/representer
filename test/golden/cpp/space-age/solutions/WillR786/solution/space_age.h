#if !defined(SPACE_AGE_H)
#define SPACE_AGE_H

namespace space_age {

    const double EARTH_SECONDS = 31557600;
    const double MERCURY_ORBIT =  0.2408467;    
    const double VENUS_ORBIT = 0.61519726;
    const double EARTH_ORBIT = 1.0;
    const double MARS_ORBIT = 1.8808158;
    const double JUPITER_ORBIT = 11.862615;    
    const double SATURN_ORBIT = 29.447498;     
    const double URANUS_ORBIT = 84.016846;    
    const double NEPTUNE_ORBIT = 164.79132;
    
    class space_age{
        
        private: 
            long scnds;

        public:
            space_age(long);
            long seconds() const;
            double on_mercury() const;
            double on_venus() const;
            double on_earth() const;
            double on_mars() const;    
            double on_jupiter() const;
            double on_saturn() const;
            double on_uranus() const;
            double on_neptune() const;
    };

}  // namespace space_age

#endif // SPACE_AGE_H