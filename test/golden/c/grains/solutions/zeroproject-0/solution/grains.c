#include "grains.h"
#include <math.h>

uint64_t square(uint8_t index) { return (uint64_t)powl(2, index - 1); }

uint64_t total(void) {
  int chess = 8 * 8;
  return (uint64_t)powl(2, chess + 1) - 1;
}

