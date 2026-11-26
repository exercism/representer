package isogram

import "strings"

func IsIsogram(word string) bool {
	validLetters := []string{"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}

	var validWord string
	var charCounter int

	// Let's compose the word with valid letters only.
	for _, char := range strings.ToLower(word) {
		for _, validLetter := range validLetters {
			if string(char) == validLetter {
				validWord += string(char)
			}
		}
	}

	// Let's iterate over each letter (outer loop). The inner loop counts how many occurences there
    // are in the word for the current letter. If some letter appears more than once, the program returs bool false.
	for _, char := range validWord {
		for _, chkChar := range validWord {
			if char == chkChar {
				charCounter++
			}
		}
		if charCounter > 1 {
			return false
		} else {
			charCounter = 0
		}
	}

	return true
}
