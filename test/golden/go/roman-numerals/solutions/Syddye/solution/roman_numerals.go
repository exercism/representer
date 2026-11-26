package romannumerals

import "errors"

var rn = [4][10]string{
    {"", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"},
    {"", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC"},
    {"", "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM"},
    {"", "M", "MM", "MMM"},
}

func ToRomanNumeral(n int) (string, error) {
    if (n <= 0 || n > 3999) {
        return "", errors.New("Out of range") 
    }
	return rn[3][n/1e3] + rn[2][n%1e3/1e2] + rn[1][n%1e2/10] + rn[0][n%10], nil
}
