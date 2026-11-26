package sieve

func Sieve(limit int) []int {
	sieve := make([]bool, limit+1)
	primes := make([]int, limit/2)
	primeIndex := 0

	for i := 2; i <= limit; i++ {
		if !sieve[i] {
			primes[primeIndex] = i
			primeIndex++
			for j := i + i; j <= limit; j += i {
				sieve[j] = true
			}
		}
	}
	return primes[:primeIndex]
}
