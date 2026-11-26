package armstrong_numbers
import "core:math"

pow :: proc(val: u128, power: u128) -> u128 {
	result: u128 = 1
	for i: u128 = 0; i < power; i += 1 {
		result *= val
	}

	return result
}

is_armstrong_number :: proc(n: u128) -> bool {
    if n == 0 { return true }
	digits := u128(math.log10(f64(n))) + 1

	armstrong: u128 = 0
	current_power_of_10: u128 = 1
	remainder := n
	for i: u128 = 0; i < digits; i += 1 {
		digit := remainder / current_power_of_10 % 10
		remainder -= digit * current_power_of_10
		current_power_of_10 *= 10
		armstrong += pow(digit, digits)
	}

	return n == armstrong
}