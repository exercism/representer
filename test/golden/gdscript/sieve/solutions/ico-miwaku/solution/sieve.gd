func primes(limit: int) -> Array:
	var sieve := range(0, limit + 1)
	sieve[0] = false
	sieve[1] = false
	
	for i in range(2, limit + 1):
		if sieve[i]:
			for j in range(i * 2, limit + 1, i):
				sieve[j] = false
	
	var result := []
	for i in range(2, limit + 1):
		if sieve[i]:
			result.push_back(i)
	return result
