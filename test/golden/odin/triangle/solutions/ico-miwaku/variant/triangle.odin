package triangle

Error :: enum {
	None,
	Not_A_Triangle,
	Unimplemented,
}

is_equilateral :: proc(a: f64, b: f64, c: f64) -> (bool, Error) {
	if err := is_valid(a, b, c); err != .None do return false, err
	return a == b && b == c, .None
}

is_isosceles :: proc(a: f64, b: f64, c: f64) -> (bool, Error) {
	if err := is_valid(a, b, c); err != .None do return false, err
	return a == b || b == c && c == a, .None
}

is_scalene :: proc(a: f64, b: f64, c: f64) -> (bool, Error) {
	if err := is_valid(a, b, c); err != .None do return false, err
	return a != b && b != c && c != a, .None
}

is_valid :: proc(a: f64, b: f64, c: f64) -> Error {
	return(
		.None if a > 0 && b > 0 && c > 0 && a + b > c && b + c > a && c + a > b else .Not_A_Triangle \
	)
}
