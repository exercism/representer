module main

pub enum Number {
	perfect
	abundant
	deficient
}

fn aliquot_sum(n int) int {
	mut sum := 0
	for i in 1 .. n {
		if n % i == 0 {
			sum += i
		}
	}

	return sum
}

// returns a `Result` type
pub fn classify(candidate int) !Number {
	if candidate <= 0 {
		return error('Classification is only possible for positive integers.')
	}

	sum := aliquot_sum(candidate)

	if candidate < sum {
		return .abundant
	} else if candidate > sum {
		return .deficient
	}

	return .perfect
}
