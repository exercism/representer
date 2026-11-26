const std = @import("std");
const mem = std.mem;

pub fn toRna(allocator: mem.Allocator, dna: []const u8) mem.Allocator.Error![]const u8 {
    var buffer = try allocator.alloc(u8, dna.len);
    for (dna, 1..) |n, i| {
        switch (n) {
            'G' => buffer[i] = 'C',
            'C' => buffer[i] = 'G',
            'T' => buffer[i] = 'A',
            'A' => buffer[i] = 'U',
            else => unreachable,
        }
    }
    return buffer;
}
