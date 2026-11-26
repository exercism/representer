#include "difference_of_squares.h"

namespace difference_of_squares
{
    int square_of_sum(int max)
    {
        int result = 0;
        for (int i = 1; i <= max; i++)
        {
            result += i;
        }

        return result * result;
    }

    int sum_of_squares(int max)
    {
        int result = 0;
        for (int i = 1; i <= max; i++)
        {
            result += i * i;
        }

        return result;
    }

    int difference(int max)
    {
        return square_of_sum(max) - sum_of_squares(max);
    }
} // namespace difference_of_squares
