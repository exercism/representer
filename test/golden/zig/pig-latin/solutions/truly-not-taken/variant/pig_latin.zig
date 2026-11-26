/// The caller owns the returned memory.
pub fn translate(allocator: std.mem.Allocator, phrase: []const u8) Error![]u8 {
    if (phrase.len == 0) return &.{};
    var result: std.ArrayList(u8) = try .initCapacity(allocator, phrase.len / 2 + 1);
    errdefer result.deinit(allocator);
    var it = std.mem.splitScalar(u8, phrase, ' ');
    while (it.next()) |word| {
        const vowel = std.mem.indexOfAny(u8, word, "aeiou") orelse word.len;
        const y = std.mem.indexOfScalar(u8, word, 'y');

        if (result.items.len > 0) result.appendAssumeCapacity(' ');

        if (vowel == 0 or word.len > 1 and
            (word[0] == 'y' and word[1] == 't' or
                word[0] == 'x' and word[1] == 'r'))
        {
            result.appendSliceAssumeCapacity(word);
            result.appendSliceAssumeCapacity("ay");
        } else if (y != null and y.? > 0 and y.? < vowel) {
            result.appendSliceAssumeCapacity(word[y.?..phrase.len]);
            result.appendSliceAssumeCapacity(word[0..y.?]);
            result.appendSliceAssumeCapacity("ay");
        } else if (word.len > 1 and word[vowel] == 'u' and word[vowel - 1] == 'q') {
            result.appendSliceAssumeCapacity(word[vowel + 1 .. word.len]);
            result.appendSliceAssumeCapacity(word[0 .. vowel + 1]);
            result.appendSliceAssumeCapacity("ay");
        } else {
            result.appendSliceAssumeCapacity(word[vowel..word.len]);
            result.appendSliceAssumeCapacity(word[0..vowel]);
            result.appendSliceAssumeCapacity("ay");
        }
    }
    return result.toOwnedSlice(allocator);
}

test translate {
    inline for (.{
        .{ "a b", "aay bay" },
        .{ "z", "zay" },
        .{ "apple", "appleay" },
        .{ "xray", "xrayay" },
        .{ "yttria", "yttriaay" },
        .{ "pig", "igpay" },
        .{ "chair", "airchay" },
        .{ "thrush", "ushthray" },
        .{ "quick", "ickquay" },
        .{ "square", "aresquay" },
        .{ "my", "ymay" },
        .{ "rhythm", "ythmrhay" },
    }) |case| {
        const english, const expected = case;
        const actual = try translate(std.testing.allocator, english);
        defer std.testing.allocator.free(actual);
        try std.testing.expectEqualStrings(expected, actual);
    }
}

pub const Error = std.mem.Allocator.Error;

const std = @import("std");
