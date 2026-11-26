// Package twofer prvides function ShareWith.
package twofer

// ShareWith return string with given name or default message "One for you, one for me".
func ShareWith(name string) string {
	one := "One for you"
	me := ", one for me."
	if name != "" {
		return one[:8] + name + me
	}
	return one + me
}
