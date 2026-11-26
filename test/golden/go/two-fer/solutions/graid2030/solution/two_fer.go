package twofer

// ShareWith should If the given name is "Alice", the result should be "One for Alice, one for me." If no name is given, the result should be "One for you, one for me."
func ShareWith(name string) string {
	if name == `` {
		name = `you`
	}
	return `One for ` + name + `, one for me.`
}
