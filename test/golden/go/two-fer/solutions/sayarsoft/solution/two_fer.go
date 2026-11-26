/*
Package twofer is the best package ever developed
*/
package twofer

// ShareWith is a share function
func ShareWith(in string) string {
	if "" == in {
		return "One for you, one for me."
	}

	return "One for " + in + ", one for me."
}