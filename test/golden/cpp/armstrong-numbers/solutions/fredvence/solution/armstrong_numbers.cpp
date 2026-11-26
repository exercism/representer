#include "armstrong_numbers.h"

#include <math.h>

namespace armstrong_numbers {

    bool is_armstrong_number(long const number){
        
        long rem = 0;
        int digit = 0;
        long sum = 0;
        long temp{0};
        temp = number;

        while (temp != 0) {
            temp /= 10;
            ++digit;
        }
        temp = number; 
        // Calculate sum of power of digits
        while (temp != 0) {
            rem = temp % 10;
            sum +=  pow(rem, digit);
            temp /= 10;
        }
        // Check for Armstrong number
        if (number == sum) return true;

         return false;
    }

}  // namespace armstrong_numbers
