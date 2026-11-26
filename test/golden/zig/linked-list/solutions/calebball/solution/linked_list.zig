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
        len: usize = 0,

        pub fn push(self: *Self, node: *Node) void {
            if (self.last) |last| {
                last.next = node;
                node.prev = last;
            } else {
                self.first = node;
            }
            self.last = node;
            self.len += 1;
        }

        pub fn pop(self: *Self) ?*Node {
            const last = self.last orelse return null;
            if (last.prev) |prev| {
                prev.next = null;
                last.prev = null;

                self.last = prev;
            } else {
                self.first = null;
                self.last = null;
            }
            self.len -= 1;
            return last;
        }

        pub fn shift(self: *Self) ?*Node {
            const first = self.first orelse return null;
            if (first.next) |next| {
                next.prev = null;
                first.next = null;

                self.first = next;
            } else {
                self.first = null;
                self.last = null;
            }
            self.len -= 1;
            return first;
        }

        pub fn unshift(self: *Self, node: *Node) void {
            if (self.first) |first| {
                first.prev = node;
                node.next = first;
            } else {
                self.last = node;
            }
            self.first = node;
            self.len += 1;
        }

        pub fn delete(self: *Self, target: *Node) void {
            var current = self.first orelse return;

            while (current != target) {
                current = current.next orelse return;
            }

            if (current.prev) |prev| {
                prev.next = current.next;
            } else {
                self.first = current.next;
            }

            if (current.next) |next| {
                next.prev = current.prev;
            } else {
                self.last = current.prev;
            }

            self.len -= 1;
        }
    };
}
