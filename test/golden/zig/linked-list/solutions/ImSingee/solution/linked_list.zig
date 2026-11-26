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
            node.next = null;

            if (self.last) |last| {
                last.next = node;
                self.last = node;
            } else {
                self.first = node;
                self.last = node;
            }
            
            self.len += 1;
        }

        pub fn pop(self: *Self) ?*Node {
            if (self.len == 0) {
                return null;
            }
            if (self.len == 1) {
                self.len = 0;
                const node = self.first.?;
                self.first = null;
                self.last = null;

                return node;
            }

            self.len -= 1;
            const node = self.last.?;
            self.last = node.prev;
            self.last.?.next = null;

            return node;
        }

        pub fn shift(self: *Self) ?*Node {
            if (self.len == 0) {
                return null;
            }
            if (self.len == 1) {
                self.len = 0;
                const node = self.first.?;
                self.first = null;
                self.last = null;

                return node;
            }

            self.len -= 1;
            const node = self.first.?;
            self.first = node.next;
            self.first.?.prev = null;

            return node;
        }

        pub fn unshift(self: *Self, node: *Node) void {
            node.prev = null;
            node.next = self.first;

            if (self.first) |first| {
                first.next = node;
                self.first = node;
            } else {
                self.first = node;
                self.last = node;
            }
            
            self.len += 1;
        }

        pub fn delete(self: *Self, node: *Node) void {
            if (self.first == node and self.last == node) {
                self.first = null;
                self.last = null;
                self.len = 0;
                return;
            }

            var modified: bool = false;

            if (node.prev) |prev| {
                prev.next = node.next;
                modified = true;
            } else {
                self.first = node.next;
            }

            if (node.next) |next| {
                next.prev = node.prev;
                modified = true;
            } else {
                self.last = node.prev;
            }

            if (modified) self.len -= 1;
        }
    };
}
