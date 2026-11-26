#include "all_your_base.h"
#include <algorithm>
#include <cmath>
#include <stdexcept>

namespace all_your_base
{
	void fill_vector_modulo(vector<unsigned>& v, unsigned num, int to_base)
	{
		while (num > 0)
		{
			v.push_back(num % to_base);
			num /= to_base;
		}
		std::reverse(v.begin(), v.end());
	}

	void to_base10(int from_base, const vector<unsigned>& in_digits, vector<unsigned>& base10_digits, unsigned& num)
	{
		int length = in_digits.size();

		if (from_base == 10)
		{
			base10_digits = in_digits;

			for (int i = 0; i < length; ++i)
			{
				num = 10 * num + base10_digits[i];
			}
		}
		else
		{
			for (int i = 0; i < length; ++i)
			{
				int x = in_digits[length - i - 1];
				unsigned y = x * std::pow(from_base, i);
				num += y;
			}
			fill_vector_modulo(base10_digits, num, 10);
		}
	}

	void from_base10(int to_base, vector<unsigned> base10_digits, vector<unsigned>& out_digits, unsigned num)
	{
		if (to_base == 10)
			out_digits = base10_digits;
		else
			fill_vector_modulo(out_digits, num, to_base);
	}

	vector<unsigned> convert(int from_base, const vector<unsigned>& in_digits, int to_base)
	{
		if (from_base < 2 || to_base < 2)
			throw std::invalid_argument("base cannot be less than 2");

		if (std::any_of(in_digits.begin(), in_digits.end(), [from_base](int x) { return x >= from_base; }))
			throw std::invalid_argument("digit is larger than the base");

		vector<unsigned> base10_digits, out_digits;
		unsigned base10_num = 0;

		to_base10(from_base, in_digits, base10_digits, base10_num);

		from_base10(to_base, base10_digits, out_digits, base10_num);

		return out_digits;
	}
} // namespace all_your_base
