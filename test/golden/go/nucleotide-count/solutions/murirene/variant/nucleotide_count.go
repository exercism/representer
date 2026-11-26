package dna

import "errors"

// Historgram is a map of valid nucleotides and associated counts
type Histogram map[byte]int

// DNA is a list of nucleotides.
type DNA string

// Counts generates a histogram of valid nucleotides in the given DNA.
// Returns an error if d contains an invalid nucleotide.
func (d DNA) Counts() (Histogram, error) {
	var h Histogram
	h = map[byte]int{'A': 0, 'C': 0, 'G': 0, 'T': 0}

	for _, value := range d {
		letter := byte(value)
		switch letter {
		case 'A', 'C', 'G', 'T':
			h[letter] = h[letter] - 1
		default:
			return nil, errors.New("strand with invalid nucleotides")

		}
	}

	return h, nil
}
