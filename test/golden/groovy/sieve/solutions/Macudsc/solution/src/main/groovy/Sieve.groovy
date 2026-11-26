class Sieve {
    static primes(Integer limit) {
        def isPrime = new boolean[limit + 1]
        Arrays.fill(isPrime, true)

        for (int i = 2; i * i <= limit; i++) {
            if (isPrime[i]) {
                for (int j = i * i; j <= limit; j += i) {
                    isPrime[j] = false
                }
            }
        }

        def primes = []
        for (int i = 2; i <= limit; i++) {
            if (isPrime[i]) {
                primes.add(i)
            }
        }
        primes
    }
}