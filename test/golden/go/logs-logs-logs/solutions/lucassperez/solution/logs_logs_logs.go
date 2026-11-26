package logs

import (
    "fmt"
	"unicode/utf8"
)

// Application identifies the application emitting the given log.
func Application(log string) string {
	for _, char := range(log) {
        if char == '\u2757' {
            return "recommendation"
        } else if fmt.Sprintf("%U", char) == "U+1F50D" {
        	return "search"
        } else if char == '\u2600' {
        	return "weather"
        }
    }

    return "default"
}

// Replace replaces all occurrences of old with new, returning the modified log
// to the caller.
func Replace(log string, oldRune, newRune rune) string {
	var finalString string

    for _, char := range(log) {
        if char == oldRune {
            finalString += string(newRune)
        } else {
        	finalString += string(char)
        }
    }

    return finalString
}

// WithinLimit determines whether or not the number of characters in log is
// within the limit.
func WithinLimit(log string, limit int) bool {
	return utf8.RuneCountInString(log) <= limit
}
