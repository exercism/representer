module main

fn sum(factors []int, limit int) int {
	mut ret := 0
	mut multiples := []int{}

	for factor in factors {
		if factor == 0 {
			continue
		}
		for i := factor; i < limit; {
			if i !in multiples {
				multiples << i
				ret += i
			}
			i += factor
		}
	}

	return ret
}
