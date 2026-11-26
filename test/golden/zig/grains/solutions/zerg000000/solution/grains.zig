const std = @import("std");

pub const ChessboardError = error{
    IndexOutOfBounds,
};

pub fn square(index: usize) ChessboardError!u64 {
    if (index < 1 or index > 64) {
        return ChessboardError.IndexOutOfBounds;
    }
    return std.math.pow(u64, 2, index - 1);
}

pub fn total() u64 {
    var i: u64 = 0;

    for (1..65) |x| {
        i += square(x) catch continue;
    }
    return i;
}
