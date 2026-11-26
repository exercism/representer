#include "matching_brackets.h"

#include <map>
#include <stack>
#include <set>

namespace matching_brackets
{

    std::map<char, char> PAIRS{
        {'}', '{'},
        {']', '['},
        {')', '('},
    };

    std::set<char> OPENED_BRACKETS{'{', '[', '('};

    template <typename T>
    const T &pop_value(std::stack<T> &stack)
    {
        const T &v = std::move(stack.top());
        stack.pop();
        return v;
    }

    bool check(const std::string_view &input)
    {
        std::stack<char> aStack;
        for (char aChar : input)
        {
            if (OPENED_BRACKETS.find(aChar) != OPENED_BRACKETS.end())
            {
                aStack.push(aChar);
            }
            else if (PAIRS.find(aChar) != PAIRS.end())
            {
                if (aStack.size() == 0 || PAIRS.at(aChar) != pop_value(aStack))
                    return false;
            }
        }
        return aStack.size() == 0;
    }
} // namespace matching_brackets
