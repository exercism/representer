fn char_score(c: u8) u32 {
    const upper = if (c > 90) c - 32 else c;
    return switch (upper) {
        'A', 'E', 'I', 'O', 'U', 'L', 'N', 'R', 'S', 'T' => 1,
        'D', 'G' => 2,
        'B', 'C', 'M', 'P' => 3,
        'F', 'H', 'V', 'W', 'Y' => 4,
        'K' => 5,
        'J', 'X' => 8,
        'Q', 'Z' => 10,
        else => unreachable,
    };
}

pub fn score(s: []const u8) u32 {
    var sum: u32 = 0;
    for (s) |c| sum += char_score(c);
    return sum;
}

const std = @import("std");

pub fn main() !void {
    std.debug.print("{}\n", .{score("CABBAGE")});
    std.debug.print("{}\n", .{score("Cabbage")});
}
