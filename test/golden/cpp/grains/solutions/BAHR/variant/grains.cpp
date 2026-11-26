#include "grains.h"
#include <cmath>
#include <stdexcept>
namespace grains {

unsigned long long square(int i)
{
    if(i < 1 || i > 64)
        throw std::domain_error("error argument");
    return std::pow(2, i-1);
}

unsigned long long total()
{
    unsigned long long t{0};
    auto acc = [&t](int i){t += square(i);};
    for(int i{1}; i <= 65; ++i){
        acc(i);
    }
    return t;
}

}  // namespace grains
