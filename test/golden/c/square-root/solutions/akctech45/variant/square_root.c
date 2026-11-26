#include "square_root.h"

size_t square_root(size_t target){
    if(target == 0){
        return 0;
    }

    if(target == 1){
        return 1;
    }
    
    for(size_t i = 2; i * i < target; i++){
        if(i * i == target){
            return i;
        }
    }
    return 0;
}