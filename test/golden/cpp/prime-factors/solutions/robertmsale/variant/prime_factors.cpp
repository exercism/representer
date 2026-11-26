#include "prime_factors.h"

namespace prime_factors {
    std::vector<long long> of(long long n) {
        std::vector<long long> factors;
        for (long long i = 2; i < n; ++i) {
            while (n % i == 0) {
                factors.push_back(i);
                n /= i;
            }
        }
        return factors;
    }
}  // namespace prime_factors
