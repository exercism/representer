package isbn

import (
	"strings"
	"unicode"
)

// IsValidISBN validates an ISBN-10
func IsValidISBN(isbn string) bool {
	s := strings.ReplaceAll(isbn, "-", "")
	if len(s) != 10 {
		return false
	}
	tot := 0
	for i, r := range s {
		if unicode.IsDigit(r) {
			tot += ((10 - i) * int(r-'0'))
		} else if r == 'X' && i == 9 {
			tot += 10
		} else {
			return false
		}
	}

	return tot%11 == 0
}
