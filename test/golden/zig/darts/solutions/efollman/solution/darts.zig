pub const Coordinate = struct {
    x: f32,
    y: f32,

    pub fn init(x_coord: f32, y_coord: f32) Coordinate {
        return Coordinate{
            .x = x_coord,
            .y = y_coord,
        };
    }
    pub fn score(self: Coordinate) usize {
        const r = @sqrt(self.x * self.x + self.y * self.y);
        if (r <= 1) {
            return 10;
        } else if (r <= 5) {
            return 5;
        } else if (r <= 10) {
            return 1;
        } else {
            return 0;
        }
    }
};
