package resistor_color

Color :: enum {Black, Brown, Red, Orange, Yellow, Green, Blue, Violet, Grey, White}

code :: proc(color: Color) -> int {
	return int(color)
}

colors :: proc() -> (result: [10]Color) {
    for i in 0..<10 do result[i] = Color(i - int(min(Color)))
    return
}

