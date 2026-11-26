#if !defined(MATCHING_BRACKETS_H)
#define MATCHING_BRACKETS_H

#include <vector>
#include <map>
#include <string>

namespace matching_brackets {

    static const std::map<const char, const char> map_pairs{ {')','('}, {']','['}, {'}','{'} };
    
    bool check(const std::string&);

}  // namespace matching_brackets

#endif // MATCHING_BRACKETS_H