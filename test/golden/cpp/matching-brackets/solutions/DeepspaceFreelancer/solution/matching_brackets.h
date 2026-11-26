#if !defined(MATCHING_BRACKETS_H)
#define MATCHING_BRACKETS_H

#include <string_view>

namespace matching_brackets
{
    bool check(const std::string_view &input);
} // namespace matching_brackets

#endif // MATCHING_BRACKETS_H