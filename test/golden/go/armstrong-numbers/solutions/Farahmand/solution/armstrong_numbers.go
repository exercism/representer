package armstrong

import (
    "math"
    "strconv"
)

func IsNumber(n int) bool {
	str := strconv.Itoa(n)
    p := len(str)
    result := 0
    for _, d := range str {
        v, _ := strconv.Atoi(string(d))
        result += int(math.Pow(float64(v), float64(p)))
    }

    return result == n

}
