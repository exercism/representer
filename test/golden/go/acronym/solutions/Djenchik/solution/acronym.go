package acronym

import (
	"strings"
)
func Abbreviate(s string) (abbr string) {
	s = strings.Replace(s, "-", " ", -1)
	s = strings.Replace(s, "_", " ", -1)
	words := strings.Fields(s)
	for i := range words {
		abbr += string(words[i][0])
	}
	return strings.ToUpper(abbr)
}