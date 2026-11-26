const std = @import("std");
const mem = std.mem;

pub fn abbreviate(allocator: mem.Allocator, words: []const u8) mem.Allocator.Error![]u8 {
    var res = std.ArrayList(u8).init(allocator);

    var inWord = false;
    for (words) |c| {
        switch (c) {
            ' ', '-' => inWord = true,
            '_' => continue,
            else => {
                if (!inWord) {
                    try res.append(std.ascii.toUpper(c));
                    inWord = true;
                }
            },
        }
    }

    return res.toOwnedSlice();
}
