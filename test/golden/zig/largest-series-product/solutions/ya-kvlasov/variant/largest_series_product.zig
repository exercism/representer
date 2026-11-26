const std = @import("std");
const testing = std.testing;

pub const SeriesError = error{
    InvalidCharacter,
    NegativeSpan,
    InsufficientDigits,
};

pub fn largestProduct(digits: []const u8, span: i32) SeriesError!u64 {
    if (digits.len < span) return SeriesError.InsufficientDigits;
    if (span < 0) return SeriesError.NegativeSpan;
    var max_product: u64 = 0;
    const uspan: u32 = @intCast(span);
    for (0..digits.len - uspan - 1) |i| {
        const product = try calculateProduct(digits[i .. i + uspan]);
        if (max_product < product) max_product = product;
    }
    return max_product;
}

pub fn calculateProduct(digits: []const u8) SeriesError!u64 {
    var product: u64 = 1;
    for (digits) |ch| {
        const digit = switch (ch) {
            '0'...'9' => ch - '0',
            else => return SeriesError.InvalidCharacter,
        };
        product *= digit;
    }
    return product;
}