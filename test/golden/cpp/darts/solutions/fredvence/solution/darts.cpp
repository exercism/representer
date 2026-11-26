#include "darts.h"

namespace darts {

int score(double x, double y){
    int score{0};

    double target = x*x +y*y;
    if(target <= 1){
        score = 10;
    }else if(target > 1 && target <= 25){
        score = 5;
    }else if ( target > 25 && target <= 100 ){
        score = 1;
    }else {
        score = 0;
    }
    
    return score;
}

} // namespace darts