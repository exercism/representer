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
            node.prev = self.last;
            self.insert(node);
        }

        pub fn pop(self: *Self) ?*Node {
            return self.tryYank(self.last);
        }

        pub fn shift(self: *Self) ?*Node {
            return self.tryYank(self.first);
        }

        pub fn unshift(self: *Self, node: *Node) void {
            node.next = self.first;
            self.insert(node);
        }

        pub fn delete(self: *Self, node: *Node) void {
            var current = self.first;
            while (current) |list_node| : (current = list_node.next) {
                if (list_node.data == node.data) {
                    self.yank(list_node);
                    break;
                }
            }
        }

        fn insert(self: *Self, node: *Node) void {
            if (node.next == null) {
                if (self.last) |last| {
                    last.next = node;
                }
                self.last = node;
            }
            if (node.prev == null) {
                if (self.first) |last| {
                    last.prev = node;
                }
                self.first = node;
            }
            self.len += 1;
        }

        fn tryYank(self: *Self, node: ?*Node) ?*Node {
            if (node) |n| {
                self.yank(n);
                return n;
            }
            return null;
        }

        fn yank(self: *Self, node: *Node) void {
            self.len -= 1;

            if (node.prev) |prev| {
                prev.next = node.next;
            } else {
                self.first = node.next;
            }

            if (node.next) |next| {
                next.prev = node.prev;
            } else {
                self.last = node.prev;
            }
        }
    };
}
