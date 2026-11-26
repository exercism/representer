#include "clock.h"
#include <sstream>
#include <iomanip>
#include <math.h>
#define MINUTES_IN_HOUR 60
#define HOURS_IN_DAY 	24
namespace date_independent{
	using std::ostringstream;
	using std::setw;
	using std::setfill;
    clock clock::at(int const h = 0, int const m = 0){
        return clock(h, m);
    }
    clock::operator string() const {
        ostringstream os;
        os  << setw(2) << setfill( '0' ) << hour <<
        ":"<< setw(2) << setfill( '0' ) << minute;
        return os.str();
    }
    clock& clock::cycle(int const m){
        auto hoursAdvance = [] (const int minutesAdvance)->int {
            // this need to behave like floor:
            // (int) floor(   70 / 60.0) ==  1
            // (int) floor( - 70 / 60.0) == -2
            // integer division rounds negative numbers towards zero
            // -70 / 60  == -1
            // to round negative numbers down,
            // an additional 1 is subtracted
            // if the remainder is negative:
            //     a % 60 < 0
            return (minutesAdvance / MINUTES_IN_HOUR) - (minutesAdvance % MINUTES_IN_HOUR < 0?1:0 );
        };
        auto mod = [] (const int a, const int n)->int {
            return ((a % n) + n) % n;
        };
        hour = mod(hour + hoursAdvance(minute + m), HOURS_IN_DAY);
        minute = mod(minute + m, MINUTES_IN_HOUR);
        return *this;
    }
    clock& clock::plus(int const m){
        return cycle(m);
    }
    clock& clock::minus(int const m){
        return cycle(-m);
    }
    bool clock::operator==(const clock& rhs) const{
        return hour == rhs.hour && minute == rhs.minute;
    }
    clock::clock(int const h, int const m):hour(h),minute(m){cycle(0);}
}
