const std = @import("std");

pub fn abbreviate(allocator: std.mem.Allocator, words: []const u8) std.mem.Allocator.Error![]u8 {
    var ls = std.ArrayList(u8).init(allocator);
    var tokens = std.mem.tokenize(u8, words, " -_");
    while (tokens.next()) |token| try ls.append(std.ascii.toUpper(token[0]));
    return ls.toOwnedSlice();
}
