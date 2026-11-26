pub const QueenError = error{
    InitializationFailure,
};

pub const Queen = struct {
    x: isize,
    y: isize,

    const Self = @This();

    pub fn init(x: isize, y: isize) !Self {
        try checkValue(x);
        try checkValue(y);

        return .{ .x = x, .y = y };
    }

    pub fn canAttack(self: Self, other: Self) !bool {
        const dx = self.x - other.x;
        const dy = self.y - other.y;

        const sameFile = dx == 0;
        const sameRank = dy == 0;

        const sameDiagonal = dx == dy or dx == -dy;

        return sameFile or sameRank or sameDiagonal;
    }

    fn checkValue(v: isize) !void {
        if (v < 0 or v >= 8) return error.InitializationFailure;
    }
};
