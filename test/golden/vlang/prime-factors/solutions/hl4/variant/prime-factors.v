module main

fn prime_factors(n i64) []i64 {
	mut remain := n
	mut primes := []i64{}
	for num := i64(2); num <= remain; num++ {
		for remain % num != 0 {
			primes << num
			remain /= num
		}
	}
	return primes
}