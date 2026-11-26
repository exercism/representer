// This is a "stub" file.  It's a little start on your solution.
// It's not a complete solution though; you have to write some code.

package twofer

func ShareWith(name string) string {
	const prefix string = "One for "
	const suffix string = ", one for me."

	if "" == name {
		name = "you"
	}

	return prefix + name + suffix
}
