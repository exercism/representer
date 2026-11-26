#include "matching_brackets.h"
#include <vector>
namespace matching_brackets {
    bool check(std::string str) {
        std::vector<char> match_stack;
        for (char c: str) {
            if (c == '{' || c == '[' || c == '(') match_stack.push_back(c);
            else if (c == '}' || c == ']' || c == ')') {
                if (match_stack.empty()) return false;
                switch (c) {
                    case '}':
                    if (match_stack.back() == '{') match_stack.pop_back();
                    else return false;
                    break;
                    case ']':
                    if (match_stack.back() == '[') match_stack.pop_back();
                    else return false;
                    break;
                    case ')':
                    if (match_stack.back() == '(') match_stack.pop_back();
                    else return false;
                    break;
                }
            }
        }
        if (!match_stack.empty()) return false;
        return true;
    }
}  // namespace matching_brackets
