package leap

import (
	"math"
)

const testVersion = 3

// IsLeapYear takes a year as an integer input and checks if input is
// a leap year based on rules:
// on every year that is evenly divisible by 4
// except every year that is evenly divisible by 100
// unless the year is also evenly divisible by 400
func IsLeapYear(x int) bool {
	return (math.Mod(float64(x), 4) == 0 ||
		math.Mod(float64(x), 100) != 0 ||
		math.Mod(float64(x), 400) == 0)
}