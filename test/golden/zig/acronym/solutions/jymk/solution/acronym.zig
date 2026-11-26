const std = @import("std");
const mem = std.mem;

pub fn abbreviate(allocator: mem.Allocator, words: []const u8) mem.Allocator.Error![]u8 {
    var arr = std.ArrayList(u8).init(allocator);
    defer arr.deinit();
    var flag = true;
    for (words) |c| {
        switch (c) {
            'a'...'z' => {
                if (flag) {
                    try arr.append(std.ascii.toUpper(c));
                    flag = false;
                }
            },
            'A'...'Z' => {
                if (flag) {
                    try arr.append(c);
                    flag = false;
                }
            },
            '\'' => {},
            else => {
                flag = true;
            },
        }
    }
    // print("arr={s}\n", .{arr.items});
    return arr.toOwnedSlice();
}
