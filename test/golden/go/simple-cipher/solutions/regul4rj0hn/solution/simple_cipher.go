// Package cipher implements a simple shift cipher like Caesar and a more secure substitution cipher
package cipher

import (
	"strings"
)

type shift struct {
	distance int
}

type vigenere struct {
	distances []int
}

// NewCaesar creates a new Caesar Cipher with a fixed shift distance of 3 (namely D, for A)
func NewCaesar() Cipher {
	return &shift{distance: 3}
}

// NewShift allows for a flexible shift distance
func NewShift(distance int) Cipher {
	if distance < -25 || distance == 0 || distance > 25 {
		return nil
	}
	return &shift{distance: distance}
}

// Encode uses the current shift to Encode the input string
func (c shift) Encode(input string) string {
	var sb strings.Builder
	sb.Grow(len(input))
	for _, r := range strings.ToLower(input) {
		switch {
		case r >= 'a' && r <= 'z':
			sb.WriteRune(shiftRune(r, c.distance))
		}
	}
	return sb.String()
}

// Decode uses the current shift to Decode the input string
func (c shift) Decode(input string) string {
	var sb strings.Builder
	sb.Grow(len(input))
	for _, r := range strings.ToLower(input) {
		switch {
		case r >= 'a' && r <= 'z':
			sb.WriteRune(shiftRune(r, 26-c.distance))
		}
	}
	return sb.String()
}

// NewVignere creates a new Vigenere instance with a list of distances based on the key
func NewVigenere(key string) Cipher {
	if key == "" {
		return nil
	}

	var valid bool = false
	distances := make([]int, 0, len(key))
	for _, r := range key {
		if r < 'a' || r > 'z' {
			valid = false
			break
		}
		if r != 'a' {
			valid = true
		}
		distances = append(distances, int(r-'a'))
	}

	if !valid {
		return nil
	}
	return &vigenere{distances: distances}
}

// Encode uses the current vigenere distances to Encode the input string
func (v vigenere) Encode(input string) string {
	var sb strings.Builder
	sb.Grow(len(input))

	var idx int
	for _, r := range strings.ToLower(input) {
		switch {
		case r >= 'a' && r <= 'z':
			sb.WriteRune(shiftRune(r, v.distances[idx%len(v.distances)]))
			idx++
		}
	}
	return sb.String()
}

// Decode uses the current vigenere distances to Decode the input string
func (v vigenere) Decode(input string) string {
	var sb strings.Builder
	sb.Grow(len(input))

	var idx int
	for _, r := range strings.ToLower(input) {
		switch {
		case r >= 'a' && r <= 'z':
			sb.WriteRune(shiftRune(r, -v.distances[idx%len(v.distances)]))
			idx++
		}
	}
	return sb.String()
}

// shiftRune replaces the rune `r` passed by parameter with the one at `distance` position
func shiftRune(r rune, distance int) rune {
	if distance < 0 {
		distance = 26 + distance
	}
	idx := (int(r-'a') + distance) % 26
	return rune('a' + idx)
}
