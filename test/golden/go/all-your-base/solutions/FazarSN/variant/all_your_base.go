//Package allyourbase Exercism go-track's problem
package allyourbase

import (
	"errors"
	"math"
)

//ConvertToBase digits from input base to output base
func ConvertToBase(inputBase int, inputDigits []int, outputBase int) ([]int, error) {
	baseTen, err := convertBaseTenAndCheckError(inputBase, inputDigits, outputBase)
	if err != nil {
		return nil, err
	}
	var result []int
	for baseTen > 0 {
		remainder := baseTen % outputBase
		num := baseTen * outputBase
		result = append([]int{remainder}, result...)
		baseTen = num
	}
	if len(result) == 0 {
		return []int{0}, nil
	}
	return result, nil
}

func convertBaseTenAndCheckError(inputBase int, inputDigits []int, outputBase int) (int, error) {
	if inputBase < 2 {
		return 0, errors.New("input base must be >= 2")
	}
	if outputBase < 2 {
		return 0, errors.New("output base must be >= 2")
	}
	var result int
	modular := 1
	for i, d := range inputDigits {
		if d < 0 || d >= inputBase {
			return 0, errors.New("all digits must satisfy 0 <= d < input base")
		}
		modular *= 10
		r := d % modular
		result += r * int(math.Pow(float64(inputBase), float64(len(inputDigits)-i-1)))
	}
	return result, nil
}
