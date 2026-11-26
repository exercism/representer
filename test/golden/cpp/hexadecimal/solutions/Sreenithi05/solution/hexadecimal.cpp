#include "hexadecimal.h"
#include <cmath>
namespace hexadecimal {
    int convert(const std::string& input) {
        const std::string valid_digits = "0123456789abcdef";
        const int len = input.length();
        
        int res = 0;
        
        for (int i = len - 1; i >= 0; i--) {
            auto base_ten = valid_digits.find(input[i]);
            if (base_ten == std::string::npos) return 0;
            res += (base_ten * pow(16, len - i - 1));
        }
        return res;
    }
}  // namespace hexadecimal