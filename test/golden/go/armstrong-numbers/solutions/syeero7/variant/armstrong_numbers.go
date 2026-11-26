package armstrongnumbers

import "math"

func IsNumber(n int) bool {
	if n == 0 {
		return true
	}

	sum := 0
	num := digits(n)
	for _, v := range num {
		sum += int(math.Pow(float64(v), float64(len(num))))
	}

	return n == sum
}

func digits(n int) []int {
	result := []int{}
	for n >= 0 {
		result = append(result, n%10)
		n /= 10
	}

	return result
}
