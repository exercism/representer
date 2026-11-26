#include "eliuds_eggs.h"

namespace chicken_coop {
    
    size_t positions_to_quantity(int value){
        std::bitset<65> bits(value);
        
        return bits.count();
}

}  // namespace chicken_coop
