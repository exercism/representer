const std = @import("std");

pub fn LinkedList(comptime T: type) type {
    return struct {
        const Self = @This();

        pub const Node = struct {
            prev: ?*Node = null,
            next: ?*Node = null,
            data: T,
        };

        first: ?*Node = null,
        last: ?*Node = null,
        len: u32 = 0,

        pub fn push(self: *Self, node: *Node) void {
            if (self.last) |*last| {
                last.*.next = node;
                node.prev = self.last;
            }
            
            self.last = node;
            if (self.first == null)
                self.first = node;

            self.len += 1;
        }

        pub fn pop(self: *Self) ?*Node {
            var back: *Node = undefined;
            if (self.last) |*last| {
                // Copy out the end of the list
                back = last.*;
                if (last.*.prev) |*prev| {
                    prev.*.next = null;
                }
                self.last = last.*.prev;
            } else {
                return null;
            }

            if (self.len > 0) {
                self.len -= 1;
            }

            // If first and last were the same node, also reset first
            if (self.len == 0) {
                self.first = null;
            }

            return back;
        }

        pub fn shift(self: *Self) ?*Node {
            // Copy out the first
            var front: *Node = undefined;
            if (self.first) |*first| {
                front = first.*;
                if (first.*.next) |*next| {
                    next.*.prev = null;
                }
                self.first = front.next;
            } else {
                return null;
            }

            if (self.len > 0) {
                self.len -= 1;
            }

            // If first and last were the same node, also reset last
            if (self.len == 0) {
                self.last = null;
            }

            return front;
        }

        pub fn unshift(self: *Self, node: *Node) void {
            if (self.first) |first| {
                first.prev = node;
            }
            node.next = self.first;
            self.first = node;

            if (self.last == null)
                self.last = self.first;

            self.len += 1;
        }

        pub fn delete(self: *Self, node: *Node) void {
            var pnode = self.first;
            while (pnode != null) : (pnode = pnode.?.next) {
                const cur_node: *Node = pnode.?;
                if (cur_node.data == node.data) {
                    // Remove this element from the list
                    if (cur_node.prev) |*prev| {
                        prev.*.next = cur_node.next;
                    }
                    if (cur_node.next) |*next| {
                        next.*.prev = cur_node.prev;
                    }
                    if (self.len > 0) {
                        self.len -= 1;
                    }

                    if (self.first) |first| {
                        if (first == cur_node) {
                            self.first = cur_node.next;
                        }
                    }
                    if (self.last) |last| {
                        if (last == cur_node) {
                            self.last = cur_node.prev;
                        }
                    }
                    break;
                }
            }
        }

        pub fn print(self: Self) void {
            var pnode = self.first;
            std.debug.print("List: ", .{});
            while (pnode != null) : (pnode = pnode.?.next) {
                if (pnode) |node| {
                    std.debug.print("[{d}] -> ", .{node.data});
                }
            }
            std.debug.print("null\n", .{});
        }
    };
}