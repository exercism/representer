#if !defined(ALL_YOUR_BASE_H)
#define ALL_YOUR_BASE_H
#include <vector>

namespace all_your_base {
using std::vector;
	vector<unsigned> convert(int from_base, const vector<unsigned>& in_digits, int to_base);
}  // namespace all_your_base

#endif // ALL_YOUR_BASE_H