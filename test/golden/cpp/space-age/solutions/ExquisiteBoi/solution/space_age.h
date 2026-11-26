#if !defined(SPACE_AGE_H)
#define SPACE_AGE_H

namespace space_age {
    namespace constants{
        const long long seconds_in_earth_year{31557600};
        const double mercury_period{0.2408467};
        const double venus_period{0.61519726};
        const double mars_period{1.8808158};
        const double jupiter_period{11.862615};
        const double saturn_period{29.447498};
        const double uranus_period{84.016846};
        const double neptune_period{164.79132}; 
    }
    
    
    class space_age {
        public:
        //Constructer
        space_age(long long time) : m_time{time} {}

        long long seconds() const{
            return m_time;
        }
        double on_earth() const{
            return static_cast<double>(seconds()) / constants::seconds_in_earth_year;
        }
        double on_mercury() const{
            return on_earth() / constants::mercury_period;
        }
        double on_venus() const{
            return on_earth() / constants::venus_period;
        }
        double on_mars() const{
            return on_earth() / constants::mars_period;
        }
        double on_jupiter() const{
            return on_earth() / constants::jupiter_period;
        }
        double on_saturn() const{
            return on_earth() / constants::saturn_period;
        }
        double on_uranus() const{
            return on_earth() / constants::uranus_period;
        }
        double on_neptune() const{
            return on_earth() / constants::neptune_period;
        }
        
        private:
        long long m_time;

    };
    
}  // namespace space_age


#endif // SPACE_AGE_H