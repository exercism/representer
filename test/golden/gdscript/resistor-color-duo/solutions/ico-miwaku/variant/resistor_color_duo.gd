func value(colors):
	return code_to_value(colors[0]) / 10 + code_to_value(colors[1])

func code_to_value(color: String) -> Variant:
	return colors().find(color)

func colors() -> Array[String]:
	return ["black", "brown", "red", "orange", "yellow", "green", "blue", "violet", "grey", "white"]
