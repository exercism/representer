const std = @import("std");

pub fn isValid(s: []const u8) bool {
    const clean_s = removeSpaces(s);
    if (clean_s.len < 1) return false;
    if (containAlpha(clean_s)) return false;

    std.mem.reverse(u8, clean_s);
    var i: usize = 0;
    var sum: u16 = 0;
    while (i < clean_s.len) {
        const c = clean_s[i];
        const num: u8 = if (c >= '0' and c <= '9') c - '0' else return false;

        if (i % 2 != 0) {
            var num2 = num * 2;
            if (num2 > 9) num2 -= 9;
            sum += num2;
        } else {
            sum += num;
        }

        i += 1;
    }

    return sum % 10 == 0;
}

fn removeSpaces(s: []const u8) []u8 {
    var builder = std.ArrayList(u8).init(std.heap.page_allocator);
    defer builder.deinit();

    for (s) |c| {
        if (c != ' ') {
            builder.append(c) catch unreachable;
        }
    }

    return builder.toOwnedSlice() catch unreachable;
}

fn containAlpha(s: []const u8) bool {
    for (s) |c| {
        if (std.ascii.isAlphabetic(c)) return true;
    }
    return false;
}
