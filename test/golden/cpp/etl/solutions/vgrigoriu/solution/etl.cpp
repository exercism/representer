#include "etl.h"

#include <algorithm>
#include <locale>
#include <utility>

namespace etl {

std::map<char, int> transform(const std::map<int, std::vector<char>>& old) {
    std::map<char, int> result {};
    std::for_each(old.cbegin(), old.cend(), [&result](auto value_to_letters) {
        auto value = value_to_letters.first;
        const auto& letters = value_to_letters.second;
        std::for_each(letters.cbegin(), letters.cend(), [&result, value](auto letter) {
            result[std::tolower(letter, std::locale::classic())] = value;
        });
    });
    return result;
}

}  // namespace etl
