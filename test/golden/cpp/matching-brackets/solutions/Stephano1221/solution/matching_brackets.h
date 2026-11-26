#if !defined(MATCHING_BRACKETS_H)
#define MATCHING_BRACKETS_H
#include <string>
#include <map>

namespace matching_brackets {
	extern std::map<char, char> bracket_pairs;
	bool check(std::string text);
}  // namespace matching_brackets

#endif // MATCHING_BRACKETS_H