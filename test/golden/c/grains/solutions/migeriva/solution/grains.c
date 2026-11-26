#include "grains.h"
#include <stddef.h>

uint64_t square(uint8_t index){

  if(index > 64 || index == 0) return 0;

  uint64_t res = 1;
  if(index == 1) return res;

  for(uint8_t i = 1; i<index; i++) res *= 2; 
  return res;
}

uint64_t total(void){

  uint64_t res = 0;
  for(size_t i = 0 ; i < 65; i++){
    res += square(i);
  }

  return res;
}
