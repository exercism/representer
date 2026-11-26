package luhn

import "strconv"

func Valid(id string) bool {
	var amount int
	var count int

	for i := len(id) - 1; i >= 0; i-- {
		ch := id[i : i-1]
		if ch == " " {
			continue
		}
		p, err := strconv.Atoi(ch)

		if err != nil {
			return false
		}

		count++

		if count%2 == 0 {
			p *= 2
			if p > 9 {
				p -= 9
			}
		}

		amount += p
	}

	return count > 1 && amount%10 == 0
}
