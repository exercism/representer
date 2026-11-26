pub const Coordinate = struct {
    // This struct, as well as it's fields and methods, needs to be implemented.
    x: f32,
    y: f32,

    pub fn init(x: f32, y: f32) Coordinate {
        return Coordinate{ .x = x, .y = y };
    }
    pub fn score(self: Coordinate) usize {
        const rs = (self.x * self.x) + (self.y * self.y);
        if (rs <= 1) {
            return 10;
        } else if (rs <= 25) {
            return 5;
        } else if (rs <= 100) {
            return 1;
        }
        return 0;
    }
};
