package thefarm

import (
	"errors"
	"fmt"
)

var ErrNotFound = errors.New("resource was not found")

// TODO: define the 'DivideFood' function
func DivideFood(fc FodderCalculator, numOfCow int) (float64, error) {
	fa, errFA := fc.FodderAmount(numOfCow)
	if errFA != nil {
		return 0, errFA
	}

	ff, errFF := fc.FatteningFactor()
	if errFF != nil {
		return 0, errFF
	}

	return (fa / float64(numOfCow)) / ff, nil
}

// TODO: define the 'ValidateInputAndDivideFood' function
func ValidateInputAndDivideFood(fc FodderCalculator, numOfCow int) (float64, error) {
	if numOfCow <= 0 {
		return 0, errors.New("invalid number of cows")
	}

	return DivideFood(fc, numOfCow)
}

// TODO: define the 'ValidateNumberOfCows' function
type InvalidCowsError struct {
	numOfCows  int
	errMessage string
}

func (e *InvalidCowsError) Error() string {
	return fmt.Sprintf("%d cows are invalid: %s", e.numOfCows, e.errMessage)
}

func ValidateNumberOfCows(numOfCow int) error {
	if numOfCow < 0 {
		return &InvalidCowsError{
			numOfCows:  numOfCow,
			errMessage: "there are no negative cows",
		}
	}

	if numOfCow == 0 {
		return &InvalidCowsError{
			numOfCows:  0,
			errMessage: "no cows don't need food",
		}
	}

	return nil
}

// Your first steps could be to read through the tasks, and create
// these functions with their correct parameter lists and return types.
// The function body only needs to contain `panic("")`.
//
// This will make the tests compile, but they will fail.
// You can then implement the function logic one by one and see
// an increasing number of tests passing as you implement more
// functionality.
