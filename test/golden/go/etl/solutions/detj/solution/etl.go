package etl

import "strings"

func Transform(in map[int][]string) map[string]int {
	transformed := make(map[string]int)

	for point, letters := range in {
		for _, letter := range letters {
			transformed[strings.ToLower(letter)] = point
		}
	}

	return transformed
}
