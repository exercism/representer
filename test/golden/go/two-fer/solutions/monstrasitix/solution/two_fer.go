package twofer


func format(name string) string {
    return "One for " + name + ", one for me."
}

func ShareWith(name string) string {
    if name == "" {
        return format("you")
    } else {
    	return format(name)
    }
}
