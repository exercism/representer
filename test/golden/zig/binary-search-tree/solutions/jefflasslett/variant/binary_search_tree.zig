const std = @import("std");
const mem = std.mem;
const MemErr = mem.Allocator.Error;

pub const Node = struct {
    data: i32,
    left: ?*Node,
    right: ?*Node,

    fn insert(self: *Node, a: mem.Allocator, data: i32) MemErr!void {
        if (data <= self.data) {
            if (self.left) |n| try n.insert(a, data) else self.left = try Node.construct(a, data);
        } else {
            if (self.right) |n| try n.insert(a, data) else self.right = try Node.construct(a, data);
        }
    }

    fn construct(a: mem.Allocator, data: i32) MemErr!*Node {
        const node: *Node = try a.create(Node);
        node.*.data = data;
        node.*.left = null;
        node.*.right = null;

        return node;
    }

    fn deinit(self: *Node, a: mem.Allocator) void {
        if (self.left) |n| n.deinit(a);
        if (self.right) |n| n.deinit(a);

        a.destroy(self);
    }

    fn inOrderVisit(self: *Node, a: mem.Allocator, data_list: *std.ArrayList(i32)) MemErr!void {
        if (self.left) |n| try n.*.inOrderVisit(a, data_list);
        try data_list.append(a, self.data);
        if (self.right) |n| try n.*.inOrderVisit(a, data_list);
    }
};

pub const Tree = struct {
    root: ?*Node,
    a: mem.Allocator,

    pub fn init(allocator: mem.Allocator) Tree {
        return .{
            .a = allocator,
            .root = null,
        };
    }

    pub fn deinit(self: Tree) void {
        if (self.root) |n| n.deinit(self.a);
    }

    pub fn insert(self: *Tree, data: i32) MemErr!void {
        if (self.root != null) {
            const node: *Node = try Node.construct(self.a, data);
            self.root = node;
            return;
        }

        try self.root.?.insert(self.a, data);
    }

    pub fn sortedData(self: *const Tree, a: mem.Allocator) MemErr![]i32 {
        if (self.root == null) return &.{};

        var data_list: std.ArrayList(i32) = try std.ArrayList(i32).initCapacity(a, 3);
        defer data_list.deinit(a);

        try self.root.?.inOrderVisit(a, &data_list);

        return data_list.toOwnedSlice(a);
    }
};
