#include <string>

#include "armstrong_numbers.h"

namespace armstrong_numbers
{
    bool is_armstrong_number(int number)
    {
        int sum = 0;

        int temp = number;
        int digit = 0;
        int power = 0;
        size_t length = std::to_string(number).length();

        while (temp != 0)
        {
            digit = temp % 10;
            power = digit;

            for (int i = 1; i < static_cast<int>(length); i++)
            {
                power *= digit;
            }
            sum += power;
            temp /= 10;
        }

        return sum == number;
    }
} // namespace armstrong_numbers
