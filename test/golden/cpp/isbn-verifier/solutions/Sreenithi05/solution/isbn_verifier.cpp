#include "isbn_verifier.h"
#include <unordered_map>
namespace isbn_verifier {
    std::unordered_map<char, int> _translations {
        {'0', 0},
        {'1', 1},
        {'2', 2},
        {'3', 3},
        {'4', 4},
        {'5', 5},
        {'6', 6},
        {'7', 7},
        {'8', 8},
        {'9', 9},
        {'X', 10}
    };
    bool is_valid(const std::string &isbn)
    {
        int count = 10;
        int sum = 0;
        for(char n : isbn) {
            if((n != '-' && _translations.count(n) == 0) || (n == 'X' && count != 1)) {
                return false;
            }
            else {
                if(n != '-') {
                    sum += count * _translations.at(n);
                    count--;
                }
            }
        }
        return count == 0 && sum % 11 == 0;
    }
}  // namespace isbn_verifier