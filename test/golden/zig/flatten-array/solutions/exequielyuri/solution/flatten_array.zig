const std = @import("std");
const mem = std.mem;

const Error = mem.Allocator.Error;

pub const Box = union(enum) {
    none,
    one: i12,
    many: []const Box,

    pub fn flatten(self: @This(), allocator: mem.Allocator) Error![]i12 {
        var supplies: std.ArrayList(i12) = .empty;
        errdefer supplies.deinit(allocator);
        try self.traverse(allocator, &supplies);
        return supplies.toOwnedSlice(allocator);
    }

    fn traverse(
        self: @This(),
        allocator: mem.Allocator,
        supplies: *std.ArrayList(i12),
    ) Error!void {
        switch (self) {
            .none => {},
            .one => |supply| try supplies.append(allocator, supply),
            .many => |boxes| {
                for (boxes) |box| {
                    try box.traverse(allocator, supplies);
                }
            },
        }
    }
};

pub fn flatten(allocator: mem.Allocator, box: Box) Error![]i12 {
    return box.flatten(allocator);
}
