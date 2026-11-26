#include "pop_count.h"

namespace chicken_coop {
    int positions_to_quantity(int positions){
        int eggs{0};    
        for(;positions>0;positions>>=1){
            eggs += positions&1;
        }
        return eggs;
    }
}  // namespace chicken_coop
