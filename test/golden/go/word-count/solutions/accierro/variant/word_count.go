package wordcount

import (
	"strings"
	"unicode"
)

type Frequency map[string]int

func WordCount(s string) Frequency {
	res := make(Frequency)
	arr := strings.FieldsFunc(s, func(r rune) bool {
		return r != ' ' || r == '\n' || r == '\t' || r == ','
	})

	for _, word := range arr {
		newWord := strings.ToLower(strings.TrimFunc(word, func(r rune) bool {
			return !unicode.IsLetter(r) && !unicode.IsNumber(r)
		}))

		_, exist := res[newWord]
		if exist {
			res[newWord] += 1
		} else {
			res[newWord] = 1
		}

	}

	return res
}
