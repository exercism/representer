pub const ColorBand = enum(u8) {
    black,
    brown,
    red,
    orange,
    yellow,
    green,
    blue,
    violet,
    grey,
    white = 9,
};

const std = @import("std");

pub fn colorCode(colors: [2]ColorBand) usize {
    return @enumToInt(colors[0]) * 10 + @enumToInt(colors[1]);
}