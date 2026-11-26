#include "grains.h"

uint64_t square(uint8_t index) {
	if (index > 64) return 0; // no more than 64 squares
	if (index == 0) return 0; // no 0th square
	return 1LLU << (index - 1); // each shift left doubles the value
	// but since it's a 1-indexed field, we do index - 1 to correct
}

uint64_t total(void) {
	uint64_t total = 0; // to represent total grain across the board
	
	// just calling the function for every square and adding to total
	for (uint8_t i = 1; i <= 64; i++) {
		total += square(i);
	}
	return total;
}
