const std = @import("std");
const mem = std.mem;
const ArrayList = std.ArrayList;

pub fn abbreviate(allocator: mem.Allocator, words: []const u8) mem.Allocator.Error![]u8 {
    var acronym = ArrayList(u8).init(allocator);
    defer acronym.deinit();

    var start_of_word = true;
    for (words) |c| {
        if (c == '_') continue;
        if (start_of_word and (c >= 'a' and c <= 'z' or c >= 'A' and c <= 'Z')) {
            try acronym.append(if (c >= 'a') c - 'a' + 'A' else c);
            start_of_word = false;
        } else if (c == ' ' or c == '-') {
            start_of_word = true;
        }
    }

    return acronym.toOwnedSlice();
}
