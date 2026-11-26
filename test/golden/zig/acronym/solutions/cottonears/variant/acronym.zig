const std = @import("std");
const mem = std.mem;

pub fn abbreviate(allocator: mem.Allocator, words: []const u8) mem.Allocator.Error![]u8 {
    var acronyms = std.ArrayList(u8).init(allocator);
    var incl_next = true; // true => the next alphanumeric character will be included
    for (words) |c| {
        if (incl_next or std.ascii.isAlphanumeric(c)) {
            try acronyms.append(std.ascii.toUpper(c));
            incl_next = false;
            continue;
        }
        incl_next = incl_next or c == '-' or std.ascii.isWhitespace(c);
    }
    return acronyms.toOwnedSlice();
}
