package perfect

import "errors"

// Define the Classification type here.

type Classification string

const ClassificationDeficient Classification = "Deficient"
const ClassificationPerfect Classification = "Perfect"
const ClassificationAbundant Classification = "Abundant"

var ErrOnlyPositive = errors.New("only positive numbers")

func Classify(n int64) (Classification, error) {
	if n <= 0 {
		return ClassificationAbundant, ErrOnlyPositive
	}

	factorsSum := int64(0)

	for i := int64(1); i < n; i++ {
		if n%i == 0 {
			factorsSum += i
		}
	}

	if factorsSum == n {
		return ClassificationPerfect, nil
	} else if factorsSum >= n {
		return ClassificationAbundant, nil
	}

	return ClassificationDeficient, nil
}
