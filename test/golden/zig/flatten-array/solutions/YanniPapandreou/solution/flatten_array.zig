const std = @import("std");
const mem = std.mem;

pub const Box = union(enum) {
    none,
    one: i12,
    many: []const Box,
};

pub fn flatten(allocator: mem.Allocator, box: Box) mem.Allocator.Error![]i12 {
    var list: std.ArrayList(i12) = .empty;
    errdefer list.deinit(allocator);

    try flattenHelper(allocator, &list, box);

    return try list.toOwnedSlice(allocator);
}

fn flattenHelper(allocator: mem.Allocator, list: *std.ArrayList(i12), box: Box) mem.Allocator.Error!void {
    switch (box) {
        .none => {}, // skip null-like values completely
        .one => |v| {
            try list.append(allocator, v);
        },
        .many => |boxes| {
            for (boxes) |b| {
                try flattenHelper(allocator, list, b); // Recursively process all nested boxes
            }
        },
    }
}
