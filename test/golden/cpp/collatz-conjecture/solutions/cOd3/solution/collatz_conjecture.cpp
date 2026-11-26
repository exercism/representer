#include "collatz_conjecture.h"
#include <iostream>
namespace collatz_conjecture {
    int steps(int num){
        if(num <= 0) throw std::domain_error("Invalid number");
        int cnt = 0;
        while(num != 1){
            num & 1 ? num = 3*num+1 : num /= 2;
            cnt++;
        }
        return cnt;
    }
}  // namespace collatz_conjecture
