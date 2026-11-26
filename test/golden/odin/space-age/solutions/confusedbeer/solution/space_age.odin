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
    switch planet {
        case .Mercury:
            return (f64(seconds) / (0.2408467 * 31557600))
        case .Venus:
            return (f64(seconds) / (0.61519726 * 31557600))
        case .Earth:
            return (f64(seconds) / (1.0 * 31557600))
        case .Mars:
            return (f64(seconds) / (1.8808158 * 31557600))
        case .Jupiter:
            return (f64(seconds) / (11.862615 * 31557600))
        case .Saturn:
            return (f64(seconds) / (29.447498 * 31557600))
        case .Uranus:
            return (f64(seconds) / (84.016846 * 31557600))
        case .Neptune:
            return (f64(seconds) / (164.79132 * 31557600))
    }
	return 0.0
}
