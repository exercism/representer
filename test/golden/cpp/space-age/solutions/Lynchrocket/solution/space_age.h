#if !defined(SPACE_AGE_H)
#define SPACE_AGE_H

namespace space_age
{
#define ll long long
    class space_age
    {
    private:
        ll second_age;
        double earth_age;

    public:
        space_age(ll seconds) : second_age(seconds), earth_age(seconds / 31557600.0) {}
        ~space_age(){}
        ll seconds() const { return second_age; }
        double on_mercury() const { return earth_age / 0.2408467; }
        double on_venus() const { return earth_age / 0.61519726; }
        double on_earth() const { return earth_age; }
        double on_mars() const { return earth_age / 1.8808158; }
        double on_jupiter() const { return earth_age / 11.862615; }
        double on_saturn() const { return earth_age / 29.447498; }
        double on_uranus() const { return earth_age / 84.016846; }
        double on_neptune() const { return earth_age / 164.79132; }
    };
} // namespace space_age

#endif // SPACE_AGE_H