const std = @import("std");

pub const ComputationError = error{
    IllegalArgument,
};

pub fn steps(number: usize) anyerror!usize {
    if(number == 0) {
        return ComputationError.IllegalArgument;
    }
    var i = @as(usize, 0);
    var n = @as(usize, number);
    while (true) {
        if (n == 1) {
            break;
        }
        if (@rem(n, 2) == 0) {
            n = n / 2;
        } else {
            n = 1 + n * 3;
        }
        i += 1;
    }
    return i;
}

