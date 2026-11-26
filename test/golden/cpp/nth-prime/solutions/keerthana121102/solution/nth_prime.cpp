#include "nth_prime.h"
#include <stdexcept>
namespace nth_prime {
    int nth(unsigned int n) {
        if(n == 0) {
            throw std::domain_error("invalid index");
        }
        for(int i = 2;; ++i) {
            bool pr = true;
            for(long long int j = 2; j*j <= i; ++j) {
                if(i%j == 0) {
                    pr = false;
                    break;
                }
            }
            if(pr) {
                if(--n == 0) {
                    return i;
                }
            }
        }
    }
}
