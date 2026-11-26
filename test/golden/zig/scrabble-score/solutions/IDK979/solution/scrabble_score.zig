const std = @import("std");

pub fn letterValue(chr: u8) u32 {
    return switch (std.ascii.toLower(chr)) {
        97, 101, 105, 111, 117, 108, 110, 114, 115, 116 => 1,
        100, 103 => 2,
        98, 99, 109, 112 => 3,
        102, 104, 118, 119, 121 => 4,
        107 => 5,
        106, 120 => 8,
        113, 122 => 10,
        else => @panic("invalid char"),
    };
}

pub fn score(s: []const u8) u32 {
    var res: u32 = 0;

    for (s) |chr| {
        res += letterValue(chr);
    }

    return res;
}
