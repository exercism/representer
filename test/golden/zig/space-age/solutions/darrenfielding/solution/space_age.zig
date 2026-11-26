pub const Planet = enum {
    const earth_s = 365.25 * 24 * 60 * 60;
    const earth_y = [_]f64{
        0.2408467,
        0.61519726,
        1.0,
        1.8808158,
        11.862615,
        29.447498,
        84.016846,
        164.79132,
    };
    mercury,
    venus,
    earth,
    mars,
    jupiter,
    saturn,
    uranus,
    neptune,

    pub fn age(self: Planet, seconds: usize) f64 {
        return @intToFloat(f64, seconds) / earth_s / earth_y[@enumToInt(self)];
    }
};
