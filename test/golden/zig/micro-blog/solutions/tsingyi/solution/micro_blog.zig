const std = @import("std");
const unicode = std.unicode;

pub fn truncate(phrase: []const u8) []const u8 {
    var iter = unicode.Utf8View.initUnchecked(phrase).iterator();
    return iter.peek(5);
}
