// Package twofer resolves problem with one input
// and two devided outputs, just like a twofer cabling device
package twofer

const prefix, suffix = "One for ", ", one for me."

// ShareWith shares input of something with someone with name in one to one outputs.
func ShareWith(name string) string {
	if len(name) == 0 {
		name = "you"
	}
	return prefix + name + suffix
}
