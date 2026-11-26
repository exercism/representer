package armstrong

import (
	"math"
)

func IsNumber(n int) bool {
	d := getDigits(n)
	tempN := n
	var sum int
	for tempN > 0 {
		r := tempN % 10
		tempN /= 10
		sum += int(math.Pow(float64(r), float64(d)))
	}

	if sum == n {
		return true
	}

	return false
}

func getDigits(n int) (d int) {
	for n > 0 {
		n /= 10
		d++
	}
	return
}
