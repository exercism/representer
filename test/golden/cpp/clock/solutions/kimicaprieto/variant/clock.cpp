#include "clock.h"

namespace date_independent {

	clock::clock(int h, int m):hour(h), minute(m) {
	}

	clock clock::at(int h, int m) {
		
		return clock().plus(m, h);
	}

	clock::operator std::string () const {
		char time[]{"00:00"};

		sprintf(time, "%02d:%02d", hour, minute);

		return time;
	}

	clock& clock::plus(int m, int h){
		
		//Convert hours in minutes and sum to minutes.
		minute += (h * 60) + (hour * 60) + m;

		//Div for 1440 (24h * 60min)  and remainder is minutes of a day.
		int min_day = minute % 1440;
		//If minutes are negative valour, function substract there minutes to 24hour.
		if (min_day < 0) min_day += 1440;

		//Minutes of one day divided by 60, it's hour.
		hour = min_day / 60;

		//Remaind of division between minutes of one day and 60, it's minutes.
		minute = min_day % 60;
		
		return *this;
	}

	bool clock::operator == (const clock clock2) const {

		return (this->hour == clock2.hour) && (this->minute == clock2.minute); 

	}
	
	bool clock::operator != (const clock clock2) const {
		return (this->hour != clock2.hour) && (this->minute != clock2.minute);
	}
}  // namespace date_independent
