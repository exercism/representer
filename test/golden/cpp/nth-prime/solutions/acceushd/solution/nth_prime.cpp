#include "nth_prime.h"

namespace nth_prime {
    long MAX_SIZE = 1000005;

    void sieve(vector<int>& primes) {
        bool IsPrime[1000005];
        memset(IsPrime,true, sizeof(IsPrime));

        for(int p = 2;p * p < MAX_SIZE;p++) {
            if(IsPrime[p] == true) {
                for(int i = p *p; i < MAX_SIZE; i += p) {
                    IsPrime[i] = false;
                }
            }
        }
        for(int i = 1; i < MAX_SIZE; i++){
            if(IsPrime[i]) {
                primes.push_back(i);
            }
        }

    }
    long nth(int n) {

        if(n <= 0) {
            throw domain_error("0 or lower");
        }
        vector<int> primes;

        sieve(primes);

        return primes[n];
    }



}  // namespace nth_prime
