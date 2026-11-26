package space_age

Planet :: enum {
	Mercury,
	Venus,
	Earth,
	Mars,
	Jupiter,
	Saturn,
	Uranus,
	Neptune,
}

age :: proc(planet: Planet, seconds: int) -> f64 {
	// Implement the procedure.

	seconds_per_earth_year : f64 = 365.25 * 24 * 60 * 60 
	factor: f64 = 1

	switch planet {
		case .Mercury: factor = 0.2408467
		case .Venus: factor = 0.61519726
		case .Mars: factor = 1.8808158
		case .Jupiter: factor = 11.862615
		case .Saturn: factor = 29.447498
		case .Uranus: factor = 84.016846
		case .Neptune: factor = 164.79132
		case .Earth: factor = 1

	}
	return f64(seconds) / (seconds_per_earth_year * factor) 
}
