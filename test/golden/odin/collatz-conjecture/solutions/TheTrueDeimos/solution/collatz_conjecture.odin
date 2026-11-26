package collatz_conjecture

// Returns the number of steps to get to a value of 1.
steps :: proc(start: int) -> (result: int, ok: bool) {
	if start <= 0 {
		return 0, false
	}

	if start == 1 {
		return 0, true
	}

	current_number := start
	steps_count := 0

	for current_number != 1 {
		if current_number % 2 == 0 {
			current_number = current_number / 2
		} else {
			current_number = 3 * current_number + 1
		}
		steps_count += 1
	}

	return steps_count, true
}
