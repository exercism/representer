const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;

pub fn recite(allocator: mem.Allocator, words: []const []const u8) mem.Allocator.Error![][]u8 {
    if (words.len == 0) {
        return &[_][]u8{};
    }

    var verses: std.ArrayListUnmanaged([]u8) = .empty;
    errdefer {
        for (verses.items) |v| allocator.free(v);
        verses.deinit(allocator);
    }

    if (words.len > 1) {
        for (0..words.len - 1) |i| {
            const verse = try fmt.allocPrint(allocator, "For want of a {s} the {s} was lost.\n", .{ words[i], words[i + 1] });

            verses.append(allocator, verse) catch |err| {
                allocator.free(verse);
                return err;
            };
        }
    }

    const lastVerse = try fmt.allocPrint(allocator, "And all for the want of a {s}.\n", .{words[0]});
    verses.append(allocator, lastVerse) catch |err| {
        allocator.free(lastVerse);
        return err;
    };

    return try verses.toOwnedSlice(allocator);
}
