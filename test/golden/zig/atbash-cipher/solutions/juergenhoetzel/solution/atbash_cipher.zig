const std = @import("std");
const mem = std.mem;

/// Encodes `s` using the Atbash cipher. Caller owns the returned memory.
pub fn encode(allocator: mem.Allocator, s: []const u8) mem.Allocator.Error![]u8 {
    var list = std.ArrayList(u8).init(allocator);
    for (s) |c| {
        if (!std.ascii.isAlphanumeric(c))
            continue;
        try list.append(if (std.ascii.isAlphabetic(c)) 'z' - std.ascii.toLower(c) + 'a' else c);
        if (@mod(list.items.len, 6) == 5)
            try list.append(' ');
    }
    if (list.getLastOrNull() == ' ') _ = list.pop();
    return list.toOwnedSlice();
}

/// Decodes `s` using the Atbash cipher. Caller owns the returned memory.
pub fn decode(allocator: mem.Allocator, s: []const u8) mem.Allocator.Error![]u8 {
    var list = std.ArrayList(u8).init(allocator);
    defer list.deinit();
    for (s) |c|
        if (c == ' ')
            continue
        else
            try list.append(if (std.ascii.isAlphabetic(c)) 'z' - std.ascii.toLower(c) + 'a' else c);
    return list.toOwnedSlice();
}
