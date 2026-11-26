#include "matching_brackets.h"

#include <algorithm>
#include <vector>
namespace matching_brackets
{
std::vector<char> bracket_left{'[', '{', '('};
std::map<char, char> bracket_pair{{']', '['}, {'}', '{'}, {')', '('}};

bool check(std::string string)
{

    std::vector<char> queue{};
    for (auto const &c : string)
    {
        if (std::find(bracket_left.begin(), bracket_left.end(), c) != bracket_left.end())
        {
            queue.emplace_back(c);
            continue;
        }
        if (bracket_pair.find(c) == bracket_pair.end())
            continue; // not bracket
        if (queue.empty())
            return false; // no char to be paired
        if (queue.back() != bracket_pair[c])
            return false; // not paired

        // paired
        queue.pop_back();
    }
    if (not queue.empty())
        return false;
    return true;
}
} // namespace matching_brackets
