package sieve

FULL_SCAN :: false

primes :: proc(limit: int) -> []int {
	xs := make([]bool, limit + 1)
	defer delete(xs)
	xs[0] = true
	xs[1] = true
	res := make([dynamic]int)
	for i := 2; i <= limit; i += 1 {
		is_prime := !xs[i]
		if is_prime {
			append(&res, i)
			when FULL_SCAN {
				for j := 2 * i; j < limit; j += 1 {
					if j % i == 0 {
						xs[j] = true
					}
				}
			} else {
				k := 2; v := k * i
				for v <= limit {
					xs[v] = true
					k += 1; v = k * i
				}
			}
		}
	}
	return res[:]
}
