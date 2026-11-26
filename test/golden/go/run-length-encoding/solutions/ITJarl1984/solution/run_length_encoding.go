package encode

import (
	"strconv"
	"strings"
	"unicode"
)

func RunLengthEncode(input string) string {

	result := []string{}
	i := 0
	count := 1

	for i < len(input) {

		currentcharacter := rune(input[i])

		if i+1 <= len(input)-1 {

			nextcharacter := rune(input[i+1])

			if currentcharacter == nextcharacter {
				count++
				i++
				continue
			}
		}

		if count == 1 {

			result = append(result, string(currentcharacter))

		} else {

			result = append(result, strconv.Itoa(count))
			result = append(result, string(currentcharacter))
			count = 1
		}

		i++
	}

	return strings.Join(result, "")
}

func RunLengthDecode(input string) string {

	digitencountered := false
	occurences := 0
	result := []string{}
	occurencesstring := []string{}

	for _, element := range input {

		if unicode.IsDigit(element) {
			digitencountered = true
			occurencesstring = append(occurencesstring, string(element))
		} else {
			if digitencountered {
				valuestring := strings.Join(occurencesstring, "")
				occurences, _ = strconv.Atoi(valuestring)
				for i := 0; i < occurences; i++ {
					result = append(result, string(element))
				}
				digitencountered = false
				occurences = 0
				occurencesstring = nil
			} else {
				result = append(result, string(element))
			}
		}
	}

	return strings.Join(result, "")
}
