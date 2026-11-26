#include "grains.h"
uint64_t square(uint8_t index){
    if (index < 1 || index > 64){return 0;}
    else{
	uint64_t x = 1;
	return (x << (index-1));}
}

uint64_t total(void){
	uint64_t x = 1;
    return (2*(x << 63))-1;
}