#include "armstrong_numbers.h"
#include <algorithm>
#include <numeric>
#include <vector>
#include <iostream>
namespace armstrong_numbers {
    int pow_positive(int base, int exp) {
        int result = 1;
        if (exp > 0) {
            for (int i = 0; i < exp; ++i) {
                result *= base;
            }
        } else {
            result = 1;
        }
        return result;
    }
    bool is_armstrong_number(int num) {
        int copy = num;
        std::vector<int> digits;
        while (copy) {
            digits.push_back(copy % 10);
            copy /= 10;
        }
        int size = digits.size();
        int r = std::accumulate(digits.cbegin(), digits.cend(), 0, [size](int a, int b) {
            return a + pow_positive(b, size);
        }); 
        std::cout << r; 
        return r == num;
    }

}  // namespace armstrong_numbers
