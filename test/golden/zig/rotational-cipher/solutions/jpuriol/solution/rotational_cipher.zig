const std = @import("std");
const mem = std.mem;

const alphabetSize = 26;

pub fn rotate(allocator: mem.Allocator, text: []const u8, shiftKey: u5) mem.Allocator.Error![]u8 {
    var result = try allocator.alloc(u8, text.len);

    for (text, 0..) |c, i| {
        const baseChar: ?u8 = switch (c) {
            'a'...'z' => 'a',
            'A'...'Z' => 'A',
            else => null,
        };

        if (baseChar) |base| {
            const rot = (c - base + shiftKey) % alphabetSize;
            result[i] = base + rot;
        } else {
            result[i] = c;
        }
    }

    return result;
}
