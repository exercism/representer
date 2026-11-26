const std = @import("std");

fn getDigitCount(num: u128) u8 {
    var n = num;
    var count: u8 = 0;
    while (n > 0) : (n /= 10) {
        count += 1;
    }
    return @max(1, count); // ensures we return 1 for input 0
}

pub fn isArmstrongNumber(num: u128) bool {
    const numDigits: u8 = getDigitCount(num);
    var total: u128 = 0;
    var n: u128 = num;
    while (n != 0) {
        const digit: u128 = n % 10; // get the least significant digit
        total += std.math.pow(u128, digit, numDigits);
        n /= 10; // drop the least significant digit
    }
    return total == num;
}
