package raindrops

import "strconv"

// Convert implements raindrop speech
func Convert(i int) string {
	var res string
	for _, word := range speech {
		if i%word.modulo == 0 {
			res += word.sound
		}
	}

	if res == "" {
		res = strconv.Itoa(i)
	}
	return res
}

var speech = []struct {
	modulo int
	sound  string
}{
	{modulo: 3, sound: "Pling"},
	{modulo: 5, sound: "Plang"},
	{modulo: 7, sound: "Plong"},
}
