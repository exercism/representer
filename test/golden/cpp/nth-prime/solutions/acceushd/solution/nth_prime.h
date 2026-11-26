#if !defined(NTH_PRIME_H)
#define NTH_PRIME_H
#include <stdexcept>
#include <vector>
#include <bits/stdc++.h>

using namespace std;

namespace nth_prime {

    long nth(int n);
    bool isPrime(int num);
    vector<int> sieve(int limit);

}  // namespace nth_prime

#endif // NTH_PRIME_H
