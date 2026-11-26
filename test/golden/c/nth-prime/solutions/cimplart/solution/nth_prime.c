#include "nth_prime.h"
#include <stdlib.h>

uint32_t sieve(uint32_t limit, uint32_t *primes, size_t max_primes);

uint32_t sieve(uint32_t limit, uint32_t *primes, size_t max_primes)
{
    uint32_t *tab = (uint32_t *)calloc(limit + 1,  sizeof(uint32_t));
    size_t prime_count = 0;
    for (uint32_t n = 2; n <= limit; ++n) {
        if (tab[n] == 0) {
            if (prime_count < max_primes)
                primes[prime_count++] = n;
            for(uint32_t m = 2; m * n <= limit; ++m) {
                tab[m * n] = 1;     //mark as not prime
            }
        }
    }
    free(tab);
    return prime_count;
}

uint32_t nth(uint32_t n)
{
    uint32_t primes[100000];
    uint32_t prime_count = sieve(200000, primes, 100000);

    if (n > 0 && n < prime_count)
        return primes[n-1];
    else    
        return 0;
}