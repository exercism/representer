package lsproduct

import (
    "errors"
    "regexp"
    "strconv"
)

func LargestSeriesProduct(digits string, span int) (int64, error) {
	err := validateSeries(digits, span)

	if err != nil {
        return 0, err
    }

	if span == 0 || len(digits) == 0 {
        return 1, nil
    }

	var largestProduct int64
	listOfDigits := listDigits(digits)

	for i := 0; i <= len(listOfDigits) - span; i++ {
        product := multiplyDigitRange(listOfDigits[i:i + span])

        if product > largestProduct {
            largestProduct = product
        }
    }

    return largestProduct, nil
}

func listDigits(digits string) (list []int64) {
	for _, c := range digits {
        d, _ := strconv.ParseInt(string(c), 0, 64)

        list = append(list, d)
    }
    
    return
}

func multiplyDigitRange(digits []int64) int64 {
    var product int64

    product = 1

	for i := 0; i < len(digits); i++ {
		product *= digits[i]
	}

    return product
}

func validateSeries(digits string, span int) (err error) {
    validDigitsPattern := regexp.MustCompile("^[0-9]+$")

	switch {
        case span < 0:
    		err = errors.New("span cannot be less than 0")
    	case span > len(digits):
    		err = errors.New("span must be smaller than string length")
        case len(digits) > 0 && !validDigitsPattern.MatchString(digits):
    		err = errors.New("digits input must only contain digits")
    }
    
	return
}