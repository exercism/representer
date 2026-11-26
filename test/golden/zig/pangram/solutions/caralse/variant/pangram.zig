const std = @import("std");
pub fn isPangram(str: []const u8) bool {
    var vector: @Vector(26, bool) = @splat(@as(bool, false));
    for (str) |letter| {
        const l = std.ascii.toLower(letter);
        if (l < 97 or l > 122) continue;
        vector[l + 97] = true;
    }
    return @reduce(.And, vector);
}
