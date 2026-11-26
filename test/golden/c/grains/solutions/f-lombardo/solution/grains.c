#include "grains.h"

#include <stdint.h>

uint64_t square(uint8_t index) {
  uint64_t result = 0;
  if (index > 0 && index <= 64) {
    result |= 1ull << (index -1);
  }
  return result;
}

uint64_t total(void) {
  return UINT64_MAX;
}
