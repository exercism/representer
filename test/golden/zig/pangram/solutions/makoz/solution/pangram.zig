const std = @import("std");

const case_offset = 'a' - 'A';
const ascii_offset = 'a';

fn isAlphabetic(c: u8) bool {
    if ((c >= 'A' and c <= 'Z') or (c >= 'a' and c <= 'z')) {
        return true;
    } else {
        return false;
    }
}

fn toLower(c: u8) u8 {
    if (c >= 'A' and c <= 'Z') {
        return c + case_offset;
    }
    return c;
}

fn asciiToIndex(c: u8) usize {
    return @intCast(c - ascii_offset);
}

fn indexToAscii(index: usize) u8 {
    return @intCast(index + ascii_offset);
}

pub fn isPangram(str: []const u8) bool {
    var result: bool = true;
    var cache = [_]u8{0} ** ('z' - 'a' + 1);

    std.debug.print(">>> {s}...\n", .{str});

    // capture input occurances
    for (str) |c| {
        if (isAlphabetic(c)) {
            cache[asciiToIndex(toLower(c))] += 1;
        }
    }

    // check for missing alphabetic characters
    for (cache, 0..) |count, i| {
        if (count == 0) {
            std.debug.print(">>> {c} missing!\n", .{indexToAscii(i)});
            result = false;
        }
    }

    std.debug.print(">>> {s}: {}\n", .{ str, result });
    return result;
}
