package isbn_verifier

import "core:strconv"

parse_digit :: proc(c: rune, check: bool = false) -> (int, bool) {
	if check && c == 'X' {
		return 10, true
	}
	return strconv.digit_to_int(c)
}

is_valid :: proc(isbn: string) -> bool {
	mult := 10
	total := 0
	for c in isbn {
		if mult < 1 {
			return false
		}
		if c == '-' {
			continue
		} else {
			d, ok := parse_digit(c, mult == 1)
			if !ok {
				return false
			}
			total += mult * d
			mult -= 1
		}
	}
	return mult == 0 && total % 11 == 0
}