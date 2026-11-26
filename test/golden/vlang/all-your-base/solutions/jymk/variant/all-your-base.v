module main

import math

// The number 42, in base 10, means:
// (4 × 10¹) + (2 × 10⁰)
// The number 101010, in base 2, means:
// (1 × 2⁵) + (0 × 2⁴) + (1 × 2³) + (0 × 2²) + (1 × 2¹) + (0 × 2⁰)
// The number 1120, in base 3, means:
// (1 × 3³) + (1 × 3²) + (2 × 3¹) + (0 × 3⁰)
fn rebase(input_base int, digits []int, output_base int) ![]int {
	if input_base < 2 {
		return error('input base must be >= 2')
	}
	if output_base < 2 {
		return error('output base must be >= 2')
	}
	mut ten := i64(0)
	for i, digit in digits {
		if digit < 0 || digit >= input_base {
			return error('all digits must satisfy 0 <= d < input base')
		}
		// 转10进制
		ten += digit * math.powi(input_base, digits.len - i - 1)
	}
	mut res := []int{}
	for ten > output_base {
		mod := int(ten) % output_base
		res << mod
		ten /= i64(output_base)
	}
	if ten > 0 {
		res << int(ten)
	}
	if res.len == 0 {
		res << 0
	}
	return res.reverse()
}
