BEGIN {
    if (n < 1) {
        print "invalid input"
        exit 1
    }
    # isprime[0] = 1
    # primes[0] = p_0, p_1, ..., p_n
    cnt = 0
    for (i = 2; cnt < n; i++) {
        if (isprime[i] != 1) primes[++cnt] = i
        #print cnt
        for (j = 1; j <= cnt && i * primes[j] < 105000; j++) {
            isprime[i * primes[j]] = 1
            if (i % primes[j] == 0) break;
        }
    }
    print primes[cnt]
}