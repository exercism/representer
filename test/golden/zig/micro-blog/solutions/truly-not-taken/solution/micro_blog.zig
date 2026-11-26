/// Returns first five characters of `phrase`.
/// Assumes that `phrase` is valid UTF-8.
pub fn truncate(phrase: []const u8) []const u8 {
    var index: usize = 0;
    var count: u8 = 0;
    while (index < phrase.len and count < 5) {
        switch (phrase[index]) {
            0...127 => {
                index += 1;
                count += 1;
            },
            192...223 => {
                index += 2;
                count += 1;
            },
            224...239 => {
                index += 3;
                count += 1;
            },
            240...247 => {
                index += 4;
                count += 1;
            },
            else => unreachable,
        }
    }
    return phrase[0..index];
}

test truncate {
    try std.testing.expectEqualStrings("hello", truncate("hello world"));
    try std.testing.expectEqualStrings("五个字的问", truncate("五个字的问候"));
}

const std = @import("std");
