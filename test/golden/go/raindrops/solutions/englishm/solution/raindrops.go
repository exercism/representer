package raindrops

import "strconv"

// Convert converts a number to a string,
// the contents of which depend on the number's factors such that:
// - If the number has 3 as a factor, output will contain 'Pling'.
// - If the number has 5 as a factor, output will contain 'Plang'.
// - If the number has 7 as a factor, output will contain 'Plong'.
// - If the number does not have 3, 5, or 7 as a factor,
//     the number's digits will be output as a string
func Convert(input int) string {
	var output string
	if input%3 == 0 {
		output += "Pling"
	}
	if input%5 == 0 {
		output += "Plang"
	}
	if input%7 == 0 {
		output += "Plong"
	}
	if output == "" {
		output = strconv.Itoa(input)
	}
	return output
}
