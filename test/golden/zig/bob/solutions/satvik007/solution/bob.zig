const std = @import("std");

pub fn response(s: []const u8) []const u8 {
    if (s.len == 0) {
        return "Fine. Be that way!";
    }
    var allCapital: bool = true;
    var silence: bool = true;
    var capital: bool = false;
    var question: bool = false;

    for (s) |c| {
        if (c >= 'a' and c <= 'z') {
            allCapital = false;
        }
        if (c >= 'A' and c <= 'Z') {
            capital = true;
        }
        if (!std.ascii.isWhitespace(c)) {
            silence = false;
            if (c == '?') {
                question = true;
            } else {
                question = false;
            }
        }
    }

    if (silence) {
        return "Fine. Be that way!";
    } else if (allCapital and capital and question) {
        return "Calm down, I know what I'm doing!";
    } else if (question) {
        return "Sure.";
    } else if (allCapital and capital) {
        return "Whoa, chill out!";
    }

    return "Whatever.";
}
