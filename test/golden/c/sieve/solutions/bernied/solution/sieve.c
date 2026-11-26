#include <stdlib.h>
#include <string.h>

#include "sieve.h"

uint32_t sieve(uint32_t limit, uint32_t *primes, size_t max_primes)
{
    char* sieve_array = (char*) calloc(limit+1, sizeof(char));
    if (!sieve_array) {
        return 0;
    }
    //sieve_array[0]=1, sieve_array[1] = 1; // not necessary as they are not part of the answer
    
    for (unsigned int p=2; p <= limit; p++)
    {
        if (sieve_array[p] == 0)
        {
            for (unsigned int i=p+p; i <= limit; i += p) {
                sieve_array[i] = 1;
            }
        }
    }

    unsigned int next_prime=0;
    for (unsigned int i=2; i <= limit && next_prime < max_primes; i++)
    {
        if (sieve_array[i] == 0)
            primes[next_prime++] = i;
    }
    free(sieve_array);
    
    return next_prime; // this is now the count of primes
}