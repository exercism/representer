const std = @import("std");

pub const ColorBand = enum(u32) {
    black,
    brown,
    red,
    orange,
    yellow,
    green,
    blue,
    violet,
    grey,
    white,
};

pub fn colorCode(colors: [2]ColorBand) u32 {
    return @enumToInt(colors[0]) * 10 + @enumToInt(colors[1]);
}
