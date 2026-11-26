const std = @import("std");
const mem = std.mem;

fn number_suffix(number: u10) []const u8 {
    return switch (number % 10) {
        1 => if (number % 100 == 11) "th" else "st",
        2 => if (number % 100 == 12) "th" else "nd",
        3 => if (number % 100 == 13) "th" else "rd",
        else => "th",
    };
}

pub fn format(allocator: mem.Allocator, name: []const u8, number: u10) ![]u8 {
    return std.fmt.allocPrint(
        allocator,
        "{s}, you are the {d}{s} customer we serve today. Thank you!",
        .{ name, number, number_suffix(number) },
    );
}
