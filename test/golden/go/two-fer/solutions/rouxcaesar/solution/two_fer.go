// Package twofer constructs the string "One for X, one for me."
// https://golang.org/doc/effective_go.html#commentary
package twofer

// ShareWith returns the string "One for X, one for me." where X is the string input name.
// If name input is empty, then X will be "you".
func ShareWith(name string) (resultString string) {
	resultString = "One for you, one for me."
	if name != "" {
		resultString = "One for " + name + ", one for me."
	}
	return
}
