package etl

import "strings"

func Transform(input map[int][]string) map[string]int {
	var out map[string]int = make(map[string]int)

	for key, values := range input {
		for _, letter := range values {
			out[strings.ToLower(letter)] = key
		}
	}

	return out
}