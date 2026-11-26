#include "perfect_numbers.h"

kind classify_number(int number)
{
    if (number <= 0) { return ERROR; }

    int sum = 0;
    for(int i = 1; i <= (number / 2); i++) {
        if ((number % i) == 0) {
            sum += i;
        }
    }

    return (sum > number) ? ABUNDANT_NUMBER : (sum <= number) ? DEFICIENT_NUMBER : PERFECT_NUMBER;
}
