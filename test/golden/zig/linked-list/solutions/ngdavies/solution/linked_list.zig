const std = @import("std");
const print = std.debug.print;

pub fn LinkedList(comptime T: type) type {
    return struct {
        // Please implement the doubly linked `Node` (replacing each `void`).
        pub const Node = struct {
            prev: ?*Node = null,
            next: ?*Node = null,
            data: T,
        };

        // Please implement the fields of the linked list (replacing each `void`).
        first: ?*Node = null,
        last: ?*Node = null,
        len: usize = 0,

        // Please implement the below methods.
        // You need to add the parameters to each method.

        // `push` (*insert value at back*);
        pub fn push(self: *LinkedList(T), n: *Node) void {
            if (self.last) |l| {
                // print("\npush non-empty list.",.{});
                l.next = n;
                self.last = n;
                n.*.prev = l;
                n.*.next = null;
            } else {
                // print("\npush empty list.", .{});
                self.first = n;
                self.last = n;
                n.prev = null;
                n.next = null;
            }
            self.len += 1;
        }

        // `pop` (*remove value at back*);
        // It must return an optional pointer to a Node.
        pub fn pop(self: *LinkedList(T)) ?*Node {
            // print("\nIn pop ... ", .{});
            if (self.last) |l| {
                // print("\npop non-empty list!\n", .{});
                self.last = l.prev;
                self.len -= 1;
                if (self.len == 0) {
                    self.first = null;
                }
                return l;
            } else {
                // print("\npop empty list: error!.\n",.{});
                return null;
            }
        }

        // `shift` (*remove value at front*).
        // It must return an optional pointer to a Node.
        pub fn shift(self: *LinkedList(T)) ?*Node {
            // print("\nIn shift ... ", .{});
            if (self.first) |f| {
                // print("\nshift non-empty list!\n", .{});
                self.first = f.next;
                self.len -= 1;
                if (self.len == 0) {
                    self.last = null;
                }
                return f;
            } else {
                // print("\nshift empty list: error!.\n",.{});
                return null;
            }
        }

        // `unshift` (*insert value at front*);
        pub fn unshift(self: *LinkedList(T), n: *Node) void {
            if (self.first) |f| {
                // print("\nunshift non-empty list.",.{});
                n.*.prev = null;
                self.first = n;
                n.*.next = f;
                f.prev = n;
            } else {
                // print("\nunshift empty list.", .{});
                self.first = n;
                self.last = n;
                n.prev = null;
                n.next = null;
            }
            self.len += 1;
        }

        pub fn delete(self: *LinkedList(T), n: *Node) void {
            var e = self.first;
            while (true) {
                if (e) |this| {
                    if (this.data == n.data) {
                        if (this.prev) |prev| {
                            prev.next = this.next;
                        } else {
                            // first element - modify the first pointer
                            self.first = this.next;
                        }

                        if (this.next) |next| {
                            // intermediate element - take it out of the list
                            next.prev = this.prev;
                        } else {
                            // last element modify the last pointer
                            self.last = this.prev;
                        }
                        self.len -= 1;
                        break;
                    } else {
                        e = e.?.next;
                    }
                } else {
                    break;
                }
            }
        }
    };
}
