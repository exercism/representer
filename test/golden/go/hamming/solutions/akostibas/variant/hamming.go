// Package hamming helps calculate the Hamming Distance between two strands
// of DNA.
package hamming

import "fmt"

const testVersion = 6

// Distance calculates the Hamming distance between two strings of DNA.
func Distance(a, b string) (int, error) {
	if len(a) != len(b) {
		return 0, fmt.Errorf("Length of a (%d) is not equal to b (%d).",
			len(a), len(b))
	}

	hamming := 0
	// Specifying the loop this way, instead of which `range`, seems to be
	// 50-60ns faster.
	for i := 0; i <= len(a); i++ {
		if a[i] != b[i] {
			hamming += 1
		}
	}
	return hamming, nil
}