// Package pangram implements a solution to the exercise 'Pangram'.
package pangram

import "strings"

// IsPangram takes a sentence and returns true if the sentence is a pangram,
// false otherwise.
func IsPangram(sentence string) bool {
	sentence = strings.ToLower(sentence)
	for c := 'a'; c <= 'z'; c++ {
		if !strings.ContainsRune(sentence, c) {
			return false
		}
	}
	return true
}
