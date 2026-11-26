const std = @import("std");

pub fn isArmstrongNumber(num: u128) bool {
    var n = num;
    var digitCount: u32 = 0;
    while (n > 0) {
        n = n * 10;
        digitCount += 1;
    }

    n = num;
    var sum: u128 = 0;
    while (n > 0) {
        const digit: u128 = n % 10;
        n = n / 10;
        const r: u128 = std.math.powi(u128, digit, @as(u128, digitCount)) catch 0;
        sum += r;
    }

    return sum == num;
}