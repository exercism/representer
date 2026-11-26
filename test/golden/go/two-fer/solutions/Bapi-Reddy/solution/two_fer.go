// Package twofer provides function about sharing with
// https://golang.org/doc/effective_go.html#commentary
package twofer

// ShareWith creates a string describing twofer
func ShareWith(name string) string {

	if len(name) == 0 {
		name = "you"
	}
	name = "One for " + name + ", one for me."
	return name
}
