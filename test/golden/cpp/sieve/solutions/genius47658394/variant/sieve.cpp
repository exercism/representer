#include "sieve.h"
#include <cmath>

namespace sieve {
    std::vector<int> primes(int n) {
        if (n < 2) 
            return {}; 
        
    
        std::vector<bool> is_prime(n + 1, true);
        is_prime[0] = is_prime[1] = false; 

        for (int p = 2; p * p <= n; ++p) {
            if (is_prime[p]) {
                for (int i = p * p; i < n; i += p) 
                    is_prime[i] = false;
                
            }
        }
    
        std::vector<int> primes_;
        for (int p = 2; p <= n; ++p) 
            if (is_prime[p]) 
                primes_.push_back(p);
            
        
        return primes_;
    }
}  // namespace sieve
