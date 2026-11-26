package twofer

func ShareWith(name string) string {

	if len(name) == 0 {
		name = "you"
	}

	var res string
	res += "One for "
	res += name
	res += ", one for me."

	return res
}
