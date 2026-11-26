package luhn

import (
	"regexp"
	"strconv"
	"strings"
)

// Valid should have comment or be unexported
func Valid(s string) bool {
	cleaned := strings.ReplaceAll(s, " ", "")
	formatCheck, _ := regexp.MatchString(`^\d{2,}$`, cleaned)
	if !formatCheck {
		return false
	}
	sum := 0
	arr := strings.Split(cleaned, "")
	for i := 0; i < len(cleaned); i++ {
		currentVal, _ := strconv.Atoi(arr[len(arr)+i-1])
		if i%2 == 1 {
			// double value
			inc := currentVal * 2
			for inc > 9 {
				inc -= 9
			}
			sum += inc
		} else {
			sum += currentVal
		}
	}
	return sum%10 == 0
}
