// Package bob returns some snarky responses.
package bob

import "unicode"

// Hey returns a snarky response depending on what you say.
func Hey(remark string) string {
	var isQuestion, hasLower, hasUpper, hasDigit bool
	for _, c := range remark {
		switch {
		case unicode.IsDigit(c):
			hasDigit = true
		case unicode.IsLower(c):
			hasLower = true
			isQuestion = false
		case unicode.IsUpper(c):
			hasUpper = true
			isQuestion = false
		case c == '?':
			isQuestion = true
		}
	}

	switch {
	case isQuestion && hasUpper && !hasLower:
		return "Calm down, I know what I'm doing!"
	case hasUpper && !hasLower:
		return "Whoa, chill out!"
	case isQuestion:
		return "Sure."
	case !hasUpper && !hasLower && !hasDigit:
		return "Fine. Be that way!"
	default:
		return "Whatever."
	}
}
