#include "binary.h"
#include<iostream>
namespace binary {
int convert(std::string input) {
    int decimal_num = 0;
    for (size_t i = 0; i < input.length(); i++) {
        if (isdigit(input[i])) {
            int digit = input[i] - '0';
            decimal_num = decimal_num + (digit * pow(2, input.length()-i-1));
        }
        else 
            return 0;
    }
    return decimal_num;
}
}  // namespace binary