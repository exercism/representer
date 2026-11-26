package wordcount

import (
	"regexp"
	"strings"
)

type Frequency map[string]int

func WordCount(phrase string) Frequency {
	freq := make(Frequency)
	re := regexp.MustCompile(`\w+('\w+)?`)
	for _, word := range re.FindAllString(strings.ToLower(phrase), -1) {
		freq[word]++
	}
	return freq
}
