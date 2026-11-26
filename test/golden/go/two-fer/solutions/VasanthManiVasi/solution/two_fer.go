//This package returns a string with a two for one string.

package twofer


// This function returns a two for one string
func ShareWith(name string) (s string) {
	s = "One for "

	if name != "" {
		s += name
	} else {
		s += "you"
	}

	return s + ", one for me."
}
