// Package twofer concatenates constant strings and variables together.
package twofer

// Header and Tail are constant strings.
const (
	Header string = "One for "
	Tail   string = ", one for me."
)

// ShareWith adds a variable titled name in the middle
// of Header and Tail constants.
// If no name is provided "you" will be used as default.
func ShareWith(name string) string {

	if name == "" {
		name = "you"
	}

	return Header + name + Tail
}
