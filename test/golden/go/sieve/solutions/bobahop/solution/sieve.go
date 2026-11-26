// Package sieve is a small library for finding prime numbers
package sieve

// BenchmarkSieve-12    	  332006	      3609 ns/op	    5264 B/op	       9 allocs/op

// Sieve calculates and returns prime numbers up to the limit
func Sieve(limit int) []int {
	composite := make([]bool, limit+1)
	primes := make([]int, limit/2)
	prime_index := 0

	for number := 2; number <= limit; number++ {
		if !composite[number] {
			primes[prime_index] = number
			prime_index++
			for idx := number + number; idx <= limit; idx += number {
				composite[idx] = true
			}
		}
	}
	return primes[:prime_index]
}