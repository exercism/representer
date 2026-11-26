const std = @import("std");
const mem = std.mem;

pub const ConversionError = error{
    InvalidInputBase,
    InvalidOutputBase,
    InvalidDigit,
};

/// Converts `digits` from `input_base` to `output_base`, returning a slice of digits.
/// Caller owns the returned memory.
pub fn convert(
    allocator: mem.Allocator,
    digits: []const u32,
    input_base: u32,
    output_base: u32,
) (mem.Allocator.Error || ConversionError)![]u32 {
    if (input_base < 2) return ConversionError.InvalidInputBase;
    if (output_base < 2) return ConversionError.InvalidOutputBase;

    var sum: u32 = 0;
    for (digits, 0..) |d, i| {
        if (d > input_base - 1) return ConversionError.InvalidDigit;
        sum += d * std.math.pow(u32, input_base, @intCast(digits.len - 1 - i));
    }

    var len: usize = 0;
    var sum1 = sum;
    while (sum1 > 0) {
        len += 1;
        sum1 /= output_base;
    }
    var output: std.ArrayList(u32) = try .initCapacity(allocator, len);
    while (len > 0) : (len -= 1) {
        const d = sum / std.math.pow(u32, output_base, @intCast(len - 1));
        sum -= d * std.math.pow(u32, output_base, @intCast(len - 1));
        try output.append(allocator, d);
    }
    if (output.items.len == 0) try output.append(allocator, 0);

    return output.toOwnedSlice(allocator);
}
