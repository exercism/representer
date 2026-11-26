package allergies

import (
	"fmt"
	"strconv"
)

func Allergies(allergies uint) []string {
	allergList := []string{
		"eggs",
		"peanuts",
		"shellfish",
		"strawberries",
		"tomatoes",
		"chocolate",
		"pollen",
		"cats",
	}
	var allergiesResult []string

	binaryString := reverse(fmt.Sprint(strconv.FormatInt(int64(allergies), 2)))

	for i, v := range binaryString {
		if i == 8 {
			break
		}
		if v == '1' {
			allergiesResult = append(allergiesResult, allergList[i])
		}
	}
	return allergiesResult
}

func AllergicTo(allergies uint, allergen string) bool {
	liste := Allergies(allergies)
	for _, i := range liste {
		if allergen == i {
			return true
		}
	}
	return false
}

func reverse(s string) string {
	rns := []rune(s) // convert to rune
	for i, j := 0, len(rns)-1; i < j; i, j = i+1, j-1 {

		// swap the letters of the string,
		// like first with last and so on.
		rns[i], rns[j] = rns[j], rns[i]
	}

	// return the reversed string.
	return string(rns)
}
