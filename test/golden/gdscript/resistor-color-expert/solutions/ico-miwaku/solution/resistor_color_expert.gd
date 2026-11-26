func resistor_label(colors: Array):
	if colors.size() == 5:
		return format_value(
				colors_to_value4(colors),
				color_to_tolerance(colors[4]))
	elif colors.size() == 4:
		return format_value(
				colors_to_value3(colors),
				color_to_tolerance(colors[3]))
	else:
		return format_value(colors_to_values(colors), "")


func format_value(value: float, tolerance: String) -> String:
	var result: String

	if value >= 1000000000:
		result = to_str(value / 1000000000) + " gigaohms"
	elif value >= 1000000:
		result = to_str(value / 1000000) + " megaohms"
	elif value >= 1000:
		result = to_str(value / 1000) + " kiloohms"
	else:
		result = to_str(value) + " ohms"

	return result + tolerance


func to_str(value) -> String:
	if value == int(value):
		return str(int(value))
	else:
		return str(value)


func colors_to_values(colors: Array) -> int:
	var value := 0
	for color in colors:
		value = value * 10 + color_to_value(color)
	return value


func colors_to_value3(colors: Array) -> int:
	return \
		colors_to_values(colors.slice(0, 2)) * \
		10 ** color_to_value(colors[2])


func colors_to_value4(colors: Array) -> int:
	return \
		colors_to_values(colors.slice(0, 3)) * \
		10 ** color_to_value(colors[3])


func color_to_value(color: String) -> int:
	return [
		"black", "brown", "red", "orange", "yellow",
		"green", "blue", "violet", "grey", "white"
	].find(color)


func color_to_tolerance(color: String) -> String:
	match color:
		"grey": return " ±0.05%"
		"violet": return " ±0.1%"
		"blue": return " ±0.25%"
		"green": return " ±0.5%"
		"brown": return " ±1%"
		"red": return " ±2%"
		"gold": return " ±5%"
		"silver": return " ±10%"
		_: return ""
