#include "etl.h"
#include <cctype>
namespace etl {
	std::map<char, int> transform(std::map<int, std::vector<char>> in)
	{
		std::map<char, int> ret;
		for (auto v : in)
		{
			for (auto elem : v.second)
			{
				ret.insert({ tolower(elem)  ,v.first });
			}
		}
		return ret;
	}
}  // namespace etl
