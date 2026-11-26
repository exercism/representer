#include "grains.h"

uint64_t square( uint8_t index )
{
    if ( index == 0ULL || index > 64ULL )
        return 0ULL;
    
    return ( 1ULL << ( index - 1 ) );
}

uint64_t total( void )
{
    uint64_t total = 0ULL;
    uint8_t index;

    for ( index = 1ULL; index != 64ULL; index++ )
        total |= (1  << ( index - 1 ) );
    
    return total;
}