package resistor_color

Color :: enum u8 {
	Black  = 0,
	Brown  = 1,
	Red    = 2,
	Orange = 3,
	Yellow = 4,
	Green  = 5,
	Blue   = 6,
	Violet = 7,
	Grey   = 8,
	White  = 9,
}

code :: proc(color: Color) -> int {
	return int(color)
}

COLORS :: [10]Color{
	.Black,
	.Brown,
	.Red,
	.Orange,
	.Yellow,
	.Green,
	.Blue,
	.Violet,
	.Grey,
	.White,
}

colors :: proc() -> [10]Color { 
	return COLORS
}