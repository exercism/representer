module main

import bitfield

const first_prime = 2

fn sieve(n int) []int {
	limit := n + 1
	mut prime_sieve := bitfield.new(limit)
	prime_sieve.set_all()
	mut prime := first_prime
	
	for prime < limit {
		// is it a prime?
		if prime_sieve.get_bit(prime) == 1 {
			// yes, all multiples of `prime` cannot be prime
			for i := prime * prime; i < limit; i += prime {
				prime_sieve.clear_bit(i)
			}
		}
		prime++
	}

	mut primes := []int{}
	for i in first_prime..limit {
		if prime_sieve.get_bit(i) == 1 {
			primes << i
		}
	}
	return primes
}

