package armstrong
import "math"
func IsNumber(i int) bool {
	var parts []int
	j := i
	for j != 0 {
		parts = append(parts, j%10)
		j /= 10
	}
	p := len(parts)
	var sum int
	for _, v := range parts {
		sum += int(math.Pow(float64(v), float64(p)))
	}
	return sum == i
}