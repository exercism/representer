package armstrong
import (
    "fmt"
    "math"
)
func IsNumber(n int) bool {
    s := fmt.Sprintf("%d", n)
	power := len(s)
    t:=0.
    for _, c := range s {
        i := int(c-'0')
        t += math.Pow(float64(i), float64(power))
    }
	return t == float64(n)
}
