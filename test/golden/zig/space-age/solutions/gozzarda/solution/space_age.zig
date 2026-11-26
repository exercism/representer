pub const Planet = enum {
    mercury,
    venus,
    earth,
    mars,
    jupiter,
    saturn,
    uranus,
    neptune,

    pub fn orbit_seconds(self: Planet) f64 {
        const year_seconds: f64 = 31557600;
        const orbit_years: f64 = switch(self) {
            Planet.mercury => 0.2408467,
            Planet.venus   => 0.61519726,
            Planet.earth   => 1.0,
            Planet.mars    => 1.8808158,
            Planet.jupiter => 11.862615,
            Planet.saturn  => 29.447498,
            Planet.uranus  => 84.016846,
            Planet.neptune => 164.79132,
        };
        return orbit_years * year_seconds;
    }

    pub fn age(self: Planet, seconds: usize) f64 {
        return @intToFloat(f64, seconds) / self.orbit_seconds();
    }
};
