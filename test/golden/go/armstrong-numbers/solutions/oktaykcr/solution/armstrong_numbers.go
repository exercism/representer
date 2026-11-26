package armstrong

import (
    "math"
    "strconv"
)

func IsNumber(n int) bool {
    var tempN = n
    var sum float64
    s := strconv.Itoa(n)
    power := len(s)
	for i:= 0; i<len(s); i++ {
		sum += math.Pow(float64(tempN % 10), float64(power))
        tempN /= 10
	}
	return int(sum) == n
}
