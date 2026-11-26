#ifndef clock_h
#define clock_h

#include <string>

namespace date_independent {

	using std::string;

	class clock
	{
		public:
			static clock at(int const hours, int const minutes);

			clock& plus(int const minutes);
			clock& minus(int const minutes);

			operator string() const;
			bool operator==(const clock& rhs) const;

		private:
			clock(int const hours, int const minutes);
			int hour;
			int minute;

			clock& cycle(int const minutes);
	};

	inline bool operator!=(const clock& lhs, const clock& rhs){
		return !(lhs == rhs);
	}
}

#endif