// Package twofer should have a package comment that summarizes what it's about.
package twofer

// ShareWith should have a comment documenting it.
func ShareWith(name string) string {
	person := "you"
	if len(name) != 0 {
		person = name
	}

	share := "One for " + person + ", one for me."
	return share
}