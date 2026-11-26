package acronym

import (
	"strings"
)

// Abbreviate String (Portable Network Graphics => PNG)
func Abbreviate(s string) (out string) {
	s = strings.Replace(s, "-", " ", -1)
	s = strings.Replace(s, "_", " ", -1)
	words := strings.Fields(s)
	for i := range words {
		out += string(words[i][0])
	}
	return strings.ToUpper(out)
}
