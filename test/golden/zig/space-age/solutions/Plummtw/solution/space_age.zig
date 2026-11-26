pub const Planet = enum {
    mercury,
    venus,
    earth,
    mars,
    jupiter,
    saturn,
    uranus,
    neptune,

    pub fn age(self: Planet, seconds: usize) f64 {
        const earth_seconds_per_year: f64 = 31557600;
        const years: f64 = @intToFloat(f64, seconds) / earth_seconds_per_year;
        return switch(self) {
            .mercury => years / 0.2408467,
            .venus => years / 0.61519726,
            .earth => years,
            .mars => years /  1.8808158,
            .jupiter => years / 11.862615,
            .saturn => years / 29.447498,
            .uranus => years / 84.016846,
            .neptune => years / 164.79132,
        };
    }
};
