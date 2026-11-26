package twofer

func ShareWith(name string) string {
    if 0 == len([]rune(name)) {
        name = "you"
    }
	return "One for " + name + ", one for me."
}
