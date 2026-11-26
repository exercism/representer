#include "armstrong_numbers.h"

namespace armstrong_numbers {

    bool is_armstrong_number(int num) {
        if (num == 0) return true;

        int digits = (int) log10(num) + 1;
        int temp = num;
        int total = 0;

        while (temp > 0) {
            total += pow((temp % 10), digits);
            temp /= 10;
        }
        return total == num;
    }

}  // namespace armstrong_numbers
