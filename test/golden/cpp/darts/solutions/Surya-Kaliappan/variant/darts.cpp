#include "darts.h"
#include<cmath>

namespace darts {

    int score(double x, double y) {
        double distance = std::sqrt(std::pow(x,2.0) + std::pow(y,2.0));
        if(distance <= 1) return 10;
        if(distance <= 5) return 5;
        if(distance < 10) return 1;
        return 0;
    }
    
}  // namespace darts
