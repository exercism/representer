#include "sieve.h"
#include <set>
namespace sieve {
    std::vector<int> primes(int ti){
        std::vector<int> vPrimes;
        std::set<int> marked;
        
        for (auto i = 2; i <= ti; i++){
            if (!(marked.count(i))){
                vPrimes.push_back(i);
                for (auto ii = i; ii <= ti; ii += i){
                    marked.insert(ii);
                }
            }
        }
        return vPrimes;
    }
}  // namespace sieve
