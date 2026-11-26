module main

fn collatz(number int) !int {
	if number <= 0 {
		return error('')
	}
	mut n := number
	mut steps := 0
	for n != 1 {
		steps += 1
		if n % 2 == 0 {
			n /= 2
		} else if n % 2 != 0 {
			n *= 3
			n += 1
		}
	}
	return steps
}
