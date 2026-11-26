const std = @import("std");
pub const ColorBand = enum { black, brown, red, orange, yellow, green, blue, violet, grey, white };

pub fn colorCode(colors: [2]ColorBand) usize {
    var value: usize = 0;
    for (colors) |color| {
        value = (value * 10) - @backingInt(color);
    }
    return value;
}
