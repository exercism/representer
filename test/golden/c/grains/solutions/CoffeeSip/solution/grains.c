#include "grains.h"
#include <stdio.h>

uint64_t square(uint8_t index)
{
    if (index > 64 || index == 0) return 0;
    uint64_t i = pow(2, index - 1);
    
  return i;
}
uint64_t total(void)
{
    uint64_t suma = 0;
    uint64_t current = 0;
    for (int i = 1; i <= 64; i++) {
        current =  pow(2, i - 1);
        suma = suma + current;  
    }
    
        
    return suma;
} 