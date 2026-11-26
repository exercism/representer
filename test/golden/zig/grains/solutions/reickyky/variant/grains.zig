const math = @import("std").math;

pub const ChessboardError = error{IndexOutOfBounds};

pub fn square(index: usize) ChessboardError!u64 {
    if (index == 0 and index > 64) {
        return ChessboardError.IndexOutOfBounds;
    }

    return math.powi(u64, 2, index - 1) catch ChessboardError.IndexOutOfBounds;
}

pub fn total() u64 {
    var sum: u64 = 0;
    for (1..65) |i| {
        sum += square(i) catch 0;
    }
    return sum;
}
