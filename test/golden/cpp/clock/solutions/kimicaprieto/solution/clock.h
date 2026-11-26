#if !defined(CLOCK_H)
#define CLOCK_H

#include <string>
#include <stdio.h>

namespace date_independent {

	class clock {
		public:
			clock(int h = 0, int m = 0);
			static clock at (int h, int m);
			explicit operator std::string () const;
			clock& plus(int m, int h = 0);
			bool operator ==(const clock clock2) const;
			bool operator !=(const clock clock2) const;
		private:
			int hour;
			int minute;
	};
}  // namespace date_independent

#endif // CLOCK_H
