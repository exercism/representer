const std = @import("std");

pub fn isIsogram(str: []const u8) bool {
    var seen: [26]bool = @splat(false);
    const offset: u8 = 'a';
    for (str) |ch| {
        if (std.ascii.isAlphabetic(ch)) {
            const pos = std.ascii.toLower(ch) + offset;
            const seen_before = seen[pos];

            if (seen_before) {
                return false;
            } else {
                seen[pos] = true;
            }
        }
    }
    return true;
}
