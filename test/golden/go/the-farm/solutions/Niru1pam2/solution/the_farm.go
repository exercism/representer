package thefarm
import "fmt"
import "errors"

// TODO: define the 'DivideFood' function
func DivideFood(fc FodderCalculator, cows int ) (float64, error) {
    result, err:= fc.FodderAmount(cows)
    if err != nil {
        return 0, err
    }

    result1, err1 := fc.FatteningFactor()

    if err1 != nil {
        return 0, err1
    }

    return result/float64(cows) * result1, nil
}
// TODO: define the 'ValidateInputAndDivideFood' function
func ValidateInputAndDivideFood(fc FodderCalculator, cows int) (float64, error) {
    if cows > 0 {
        return DivideFood(fc , cows)
    }

    if cows < 0 {
        return 0, errors.New("invalid number of cows")
    }
    
    return 0, errors.New("invalid number of cows")
}

// TODO: define the 'ValidateNumberOfCows' function
type InvalidCowsError struct {
    Cows int
    Message string
}

func (e *InvalidCowsError) Error() string {
    return fmt.Sprintf("%d cows are invalid: %s", e.Cows, e.Message)
}

func ValidateNumberOfCows(cows int) error {
    if cows < 0 {
        return &InvalidCowsError{
            Cows: cows,
            Message: "there are no negative cows",
        }
    }

    if cows == 0 {
        return &InvalidCowsError{
            Cows:cows,
            Message: "no cows don't need food",
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
