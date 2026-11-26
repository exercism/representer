const std = @import("std");

pub fn isValid(s: []const u8) bool {
    // one character or less is invalid
    if (s.len <= 1) return false;

    // std.debug.print("================\n", .{});
    var sum: usize = 0;
    var j: u8 = 0; // index following the digits found
    var nb_digits: u8 = 0; // only used to prevent a single '0' to be considered valid

    for (0..s.len) |i| {
        const idx: usize = s.len - 1 - i;
        if (std.ascii.isWhitespace(s[idx])) continue;
        if (!std.ascii.isDigit(s[idx])) return false;
 
        nb_digits += 1;
        // get value from ascii value
        const value = s[idx] - '0';

        if (j % 2 == 1) {
            const new_value = 2 * value;
            if (new_value <= 9) { 
                // std.debug.print("[{}] odd <=9: {}\n", .{idx, new_value});
                sum += new_value; 
            } else { 
                // std.debug.print("[{}] odd <=9: {}\n", .{idx, new_value - 9});
                sum += (new_value - 9); 
            }
        } else {
            // std.debug.print("[{}] even: {}\n", .{idx, value});
            sum += value; 
        }

        j += 1;
    }

    // only one digit found and sum is zero ?
    // This can only be because there is only one '0'
    // in the input string
    if (nb_digits == 1 and sum == 0) return false; 

    // std.debug.print("at the end sum = {}\n", .{sum});
    return sum % 10 == 0;
}
