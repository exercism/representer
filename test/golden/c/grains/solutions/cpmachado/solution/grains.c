#include "grains.h"

uint64_t square(uint8_t index) {
	uint64_t n = 1;
	uint8_t i;

	if(index < 1 || index > 64) {
		return 0;
	}

	for(i = 1; i < index; i++) {
		n += n;
	}
	return n;
}

uint64_t total(void) {
	return square(64) * 2 - 1;
}
