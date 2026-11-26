package bottlesong

import "fmt"

var numbers = []string{
	"no", "one", "two", "three", "four", "five",
	"six", "seven", "eight", "nine", "ten",
}

var numbersCap = []string{
	"No", "One", "Two", "Three", "Four", "Five",
	"Six", "Seven", "Eight", "Nine", "Ten",
}

func bottle(n int) string {
	if n == 1 {
		return "bottle"
	}
	return "bottles"
}

func Recite(startBottles, takeDown int) []string {
	res := []string{}
	for i := 0; i < takeDown; i++ {
		current := startBottles - i
		next := current - 1

		// add empty string separator between verses (not before the first)
		if i > 0 {
			res = append(res, "")
		}

		firstLine := fmt.Sprintf("%s green %s hanging on the wall,",
			numbersCap[current], bottle(current))
		thirdLine := "And if one green bottle should accidentally fall,"
		lastLine := fmt.Sprintf("There'll be %s green %s hanging on the wall.",
			numbers[next], bottle(next))

		res = append(res, firstLine, firstLine, thirdLine, lastLine)
	}
	return res
}
