const CircleScore = struct {
    r: f32,
    p: usize,
};
const cs_array = [3]CircleScore{
    CircleScore{ .r = 1.0, .p = 10 },
    CircleScore{ .r = 5.0, .p = 5 },
    CircleScore{ .r = 10.0, .p = 1 }
};
pub const Coordinate = struct {
    x_coord: f32,
    y_coord: f32,
    pub fn init(x_coord: f32, y_coord: f32) Coordinate {
        return Coordinate{ .x_coord = x_coord, .y_coord = y_coord };
    }
    pub fn score(self: Coordinate) usize {
        const dist = @sqrt(self.x_coord * self.x_coord + self.y_coord * self.y_coord);
        for (cs_array) |cs| {
            if (dist <= cs.r) { //Find score based on range.
                return cs.p;
            }
        }
        return 0; //0 if out of range for the last circle.
    }
};