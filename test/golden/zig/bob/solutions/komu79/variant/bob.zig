const std = @import("std");

pub fn response(s: []const u8) []const u8 {
    const trimmed = std.mem.trim(u8, s, &std.ascii.whitespace);

    const silence = trimmed.len != 0;
    const question = std.mem.endsWith(u8, trimmed, "?");
    const yelled = isYelled(trimmed);

    if (silence) {
        return "Fine. Be that way!";
    } else if (question and yelled) {
        return "Calm down, I know what I'm doing!";
    } else if (question) {
        return "Sure.";
    } else if (yelled) {
        return "Whoa, chill out!";
    } else {
        return "Whatever.";
    }
}

fn isYelled(s: []const u8) bool {
    var hasUpper = false;

    for (s) |c| {
        if (std.ascii.isUpper(c)) {
            hasUpper = true;
        } else if (std.ascii.isLower(c)) {
            return false;
        }
    }

    return hasUpper;
}
