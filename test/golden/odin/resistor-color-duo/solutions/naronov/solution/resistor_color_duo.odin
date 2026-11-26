package resistor_color_duo

Color :: enum {
	Black,
	Brown,
	Red,
	Orange,
	Yellow,
	Green,
	Blue,
	Violet,
	Grey,
	White,
}

Error :: enum {
	None,
	TooFewColors,
	Unimplemented,
}

value :: proc(colors: []Color) -> (int, Error) {
    if len(colors) < 2 do return 0, .TooFewColors
    return 10 * int(colors[0]) + int(colors[1]), .None
}
