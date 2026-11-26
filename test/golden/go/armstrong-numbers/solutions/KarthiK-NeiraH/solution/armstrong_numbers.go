package armstrong

import (
	"math"
	"strconv"
)

func IsNumber(n int) bool {
	// Convert the number to a string to find the number of digits
	numStr := strconv.Itoa(n)
	numDigits := len(numStr)

	// Calculate the sum of digits each raised to the power of the number of digits
	var sum int
	for _, digitChar := range numStr {
		digit, _ := strconv.Atoi(string(digitChar))
		sum += int(math.Pow(float64(digit), float64(numDigits)))
	}

	// Check if the sum is equal to the original number
	return sum == n
}
