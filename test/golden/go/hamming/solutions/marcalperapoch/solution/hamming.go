// Package hamming provides a distance method to calculate the Hamming difference between two DNA strands.
package hamming

import "errors"

// Distance takes two strings and returns their Hamming distance or an error if their lengths are not equal.
func Distance(a, b string) (int, error) {
	if len(a) != len(b) {
		return 0, errors.New("strands must be of equal length")
	}
	distance := 0
	for i := 0; i < len(a); i++ {
		if a[i] != b[i] {
			distance++
		}
	}
	return distance, nil
}
