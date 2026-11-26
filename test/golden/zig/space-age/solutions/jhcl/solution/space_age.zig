pub const Planet = enum {
    const earth_secs: f64 = 31557600;
    mercury,
    venus,
    earth,
    mars,
    jupiter,
    saturn,
    uranus,
    neptune,

    pub fn age(self: Planet, seconds: usize) f64 {
        return switch (self) {
            .mercury => @intToFloat(f64, seconds) / earth_secs / 0.2408467,
            .venus => @intToFloat(f64, seconds) / earth_secs / 0.61519726,
            .earth => @intToFloat(f64, seconds) / earth_secs / 1,
            .mars => @intToFloat(f64, seconds) / earth_secs / 1.8808158,
            .jupiter => @intToFloat(f64, seconds) / earth_secs / 11.862615,
            .saturn => @intToFloat(f64, seconds) / earth_secs / 29.447498,
            .uranus => @intToFloat(f64, seconds) / earth_secs / 84.016846,
            .neptune => @intToFloat(f64, seconds) / earth_secs / 164.79132,
        };
    }
};
