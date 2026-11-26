#if !defined(SPACE_AGE_H)
#define SPACE_AGE_H

#include <cstdint>
namespace space_age 
{
    class space_age { 
        public:
            space_age(long);
            long seconds() const;
            double on_earth() const;
            float on_mercury() const; 
            float on_venus() const;
            float on_mars() const;
            float on_saturn() const;
            float on_jupiter() const;
            float on_uranus() const;
            float on_neptune() const;
            float calculate(float) const;
        private:
            long year;
        
    };
}  // namespace space_age

#endif // SPACE_AGE_H