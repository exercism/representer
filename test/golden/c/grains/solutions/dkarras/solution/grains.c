#include "grains.h"

/**
 * square computes the number of grains at `square'.
 *
 *   square:  1  2  3  4
 *   grains:  1, 2, 4, 8
 *
 * This is exponential => 2^(i-1).
 *
 * @param square - a 1-based index into the 64 squares of a
 *    chessboard.
 * @return number of grains at `square'.
 */
uint64_t square(uint8_t square)
{
    if (square > 0 && square <= 64) {
        uint8_t bit = square - 1;
        return (1ULL << bit);
    }

    return 0;
}

/**
 * @return the total number of grains on a chessboard.
 */
uint64_t total(void)
{
    uint64_t total = 0;

    for (int i = 1; i < 65; i++) {
        total += square(i);
    }

    return total;
}
