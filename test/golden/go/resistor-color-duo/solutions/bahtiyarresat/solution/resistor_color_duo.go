package resistorcolorduo
import (
	"fmt"
	"strconv"
)

// Value should return the resistance value of a resistor with a given colors.
func Value(colors []string) int {
		resistorColor := map[string]int{"black": 0, "brown": 1, "red": 2,
		"orange": 3, "yellow": 4, "green": 5, "blue": 6, "violet": 7, "grey": 8, "white": 9}
	result := ""
	for index, color := range colors {
		if index > 1 {
			break
		}
		result += strconv.Itoa(resistorColor[color])
	}
	parseInt, err := strconv.Atoi(result)
	if err != nil {
		fmt.Println("Error during conversion")
	}
	return parseInt
}
