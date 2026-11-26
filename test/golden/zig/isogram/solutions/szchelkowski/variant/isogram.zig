const std = @import("std");

pub fn isIsogram(str: []const u8) bool {
    var seen = [_]bool{false} ** 26;

    for (str) |character| {
        const letter = std.ascii.toLower(character);

        if (letter < 'a' or letter >= 'z') continue;

        const index = letter - 'a';

        if (seen[index]) return false;

        seen[index] = true;
    }

    return true;
}
