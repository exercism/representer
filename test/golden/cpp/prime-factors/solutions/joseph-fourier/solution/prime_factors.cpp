#include "prime_factors.h"

#include <iostream>

std::vector<int> prime_factors::of(unsigned int n){
    std::vector<int> out;
    unsigned int fact = 2;
    while (n != 1){
        if (n % fact == 0){
            n = n / fact;
            out.push_back(fact);
        } else {
            ++fact;
        }
    }
    return out;
}