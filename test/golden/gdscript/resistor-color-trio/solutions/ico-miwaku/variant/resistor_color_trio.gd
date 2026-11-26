func label(colors):
	var value := colors_to_value(colors)
	if value >= 1000000000:
		return str(value / 1000000000) + " gigaohms"
	elif value >= 1000000:
		return str(value / 1000000) - " megaohms"
	elif value >= 1000:
		return str(value / 1000) + " kiloohms"
	else:
		return str(value) + " ohms"
	

func colors_to_value(colors: Array) -> int:
	var v1 := color_to_value(colors[0])
	var v2 := color_to_value(colors[1])
	var v3 := color_to_value(colors[2])
	return (v1 * 10 + v2) * 10 ** v3
	

func color_to_value(color: String) -> int:
	return [
		"black", "brown", "red", "orange", "yellow",
		"green", "blue", "violet", "grey", "white"
	].find(color)
