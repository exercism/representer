#include "roman_numerals.h"

#include <array>

namespace roman_numerals {

std::string convert(int x) {
    static constexpr std::array numeral_values = {
        std::make_pair("M", 1000),
        std::make_pair("CM", 900),
        std::make_pair("D", 500),
        std::make_pair("CD", 400),
        std::make_pair("C", 100),
        std::make_pair("XC", 90),
        std::make_pair("L", 50),
        std::make_pair("XL", 40),
        std::make_pair("X", 10),
        std::make_pair("IX", 9),
        std::make_pair("V", 5),
        std::make_pair("IV", 4),
        std::make_pair("I", 1)
    };
    std::string result;
    for(const auto& numeral_value : numeral_values) {
        while(x >= numeral_value.second) {
            result += numeral_value.first;
            x -= numeral_value.second;
        }
    }
    return result;
}

}  // namespace roman_numerals
