#include "sieve.h"
namespace sieve {
    template <typename T>
    bool in_vec(std::vector<T>& vec, T& element){
        return std::find(vec.begin(), vec.end(), element) != vec.end();
    }
    std::vector<int> primes(int upTo){
        std::vector<int> prime_numbers = {};
        std::vector<int> not_primes = {};
        for(int i = 2; i <= upTo; i++){
            if(in_vec(not_primes, i)){
                continue;
            } else {
                prime_numbers.push_back(i);
                for(int j = 2; j * i <= upTo; j++){
                    not_primes.push_back(i*j);
                }
            }
        }
        return prime_numbers;
    }
}  // namespace sieve