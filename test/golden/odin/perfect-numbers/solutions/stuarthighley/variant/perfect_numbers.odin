package perfect_numbers

import "core:math/bits"

Classification :: enum {
	Perfect,
	Abundant,
	Deficient,
	Undefined,
}

classify :: proc(num: uint) -> Classification {
	if num <= 1 do return num != 1 ? .Deficient : .Undefined

	// Count trailing zeros (hardware TZCNT/BSF) to factor all 2s in 1 cycle:
	// sigma(2^k) = 2^(k+1) - 1 = (1 << (k + 1)) - 1
	k := uint(bits.trailing_zeros(num))
	n := num >> k
	sigma := (uint(1) << (k + 1)) - 1

	for d := uint(3); d * d <= n; d += 2 {
		if n % d == 0 {
			p: uint = 1
			for n % d == 0 {
				n /= d
				p = p * d + 1
			}
			sigma *= p
			if sigma > 2 * num do return .Abundant
		}
	}
	if n > 1 do sigma *= 1 + n

	return sigma == 2 * num ? .Perfect : sigma > 2 * num ? .Abundant : .Deficient
}
