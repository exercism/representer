# These variables are initialized on the command line (using '-v'): - n

BEGIN {
    if (n <= 0) { print "invalid input"; exit 1}
    
    # nth prime P(n) < n*log(n)+n*loglog(n)
    for (i=1; i<=2*n*log(n)+2; i++) sieve[i] = 1
    for (j=2; j<=length(sieve); j++) {
        if (sieve[j]) {
            primes[++count] = j
            for (k=j*j; k<=length(sieve); k+=j) 
                sieve[k] = 0
        }
    }
    print primes[n]
}
