#include "etl.h"

#include <cctype>

namespace etl {
    std::map<char, int> transform(std::map<int, std::vector<char>> old) {
        std::map<char, int> out;
        for (auto point_chars : old) {
            for (auto ch : point_chars.second) {
                out.insert({tolower(ch), point_chars.first});
            }
        }

        return out;
    }
}  // namespace etl
