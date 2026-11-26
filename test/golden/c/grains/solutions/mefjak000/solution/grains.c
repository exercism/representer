#include "grains.h"
#include <stdint.h>

uint64_t square(uint8_t index);
uint64_t total(void);
uint64_t pow_l(uint64_t x, uint8_t y);

uint64_t square(uint8_t index)
{
  if (index == 0) return 0;
  if (index == 1) return 1;
  return square(index - 1) * 2;
}

uint64_t total(void) 
{
  return (square(65) - 1);
}
