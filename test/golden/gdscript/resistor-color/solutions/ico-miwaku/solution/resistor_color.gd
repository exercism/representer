func color_code(color: String) -> Variant:
	return colors().find(color)

func colors() -> Array[String]:
	return ["black", "brown", "red", "orange", "yellow", "green", "blue", "violet", "grey", "white"]
