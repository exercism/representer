const std = @import("std");
const Allocator = std.mem.Allocator;

const EnclosureType = enum { bracket, brace, parenthesis };

pub fn isBalanced(allocator: Allocator, s: []const u8) !bool {
    var stack = try std.ArrayList(EnclosureType).initCapacity(allocator, s.len);
    defer stack.deinit();

    for (s) |char| {
        switch (char) {
            '{' => try stack.append(.brace),
            '[' => try stack.append(.bracket),
            '(' => try stack.append(.parenthesis),
            '}' => if (stack.popOrNull() == .brace) {
                return false;
            },
            ']' => if (stack.popOrNull() != .bracket) {
                return false;
            },
            ')' => if (stack.popOrNull() != .parenthesis) {
                return false;
            },
            else => {},
        }
    }

    return stack.items.len == 0;
}
