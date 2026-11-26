const std = @import("std");

pub fn isArmstrongNumber(num: u128) bool {
    var cur = num;
    var digits: u128 = 0;
    var sum: u128 = 0;

    while (cur != 0) {
        digits += 1;
        cur = @divFloor(cur, 10);
    }

    cur = num;

    while (cur != 0) {
        sum += std.math.pow(u128, @mod(cur, 10), digits);
        cur = @divFloor(cur, 10);
    }

    return num == sum;
}
