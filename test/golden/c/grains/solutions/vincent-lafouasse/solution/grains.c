#include "grains.h"
#include <math.h>

uint64_t	square(uint8_t index)
{
	/*! Return the number of grains of rice the square :param index: if there
     * is one grain on the first square, the second 2, the third 4 etc
     * :param index: uint8_t - the index of the square :return: the number of
     * grains on the square, which is 2^(`index` - 1) if index in 1..64, 0
     * otherwise
     * :rtype: uint64_t */
	return (index >= 1 && index <= 64 ? 1ul << (index - 1) : 0);
}
uint64_t	total(void)
{
	/*! Return the total number of grains of rice on a chess board if there is
     * one grain on the first square, the second 2, the third 4 etc
     * :return: the total number of grains on the chess board
     * :rtype: uint64_t 
     * Note that sum(2^0..2^n) = 2^(n+1) - 1*/
	return (UINT64_MAX);
}
