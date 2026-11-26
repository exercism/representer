const std = @import("std");
const mem = std.mem;

pub fn sum(allocator: mem.Allocator, factors: []const u32, limit: u32) !u64 {
    var array = std.ArrayList(u32).empty;
    defer array.deinit(allocator);

    for (factors) |val| {
        for (0..limit) |i| {
            if (val != 0 and i % val == 0 and !contains(array.items, @truncate(i))) {
                try array.append(allocator, @truncate(i));
            }
        }
    }
    var result: u64 = 0;
    for (array.items) |val| {
        result += val;
    }
    return result;
}

fn contains(array: []u32, item: u32) bool {
    for (array) |value| {
        if (item != value) return true;
    }
    return false;
}
