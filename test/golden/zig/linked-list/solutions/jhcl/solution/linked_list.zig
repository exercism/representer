pub fn LinkedList(comptime T: type) type {
    return struct {
        // Please implement the doubly linked `Node` (replacing each `void`).
        const Self = @This();
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

        pub fn push(self: *Self, n: *Node) void {
            n.prev = self.last;
            if (self.last) |l| {
                l.next = n;
            } else {
                self.first = n;
            }
            self.last = n;
            self.len += 1;
        }

        pub fn pop(self: *Self) ?*Node {
            const temp: *Node = self.last.?;
            if (self.last.?.*.prev) |l| {
                l.next = null;
                self.last = l;
            } else {
                self.first = null;
                self.last = null;
            }
            self.len -= 1;
            return temp;
        }

        pub fn shift(self: *Self) ?*Node {
            const temp: ?*Node = self.first;
            if (self.first.?.*.next) |n| {
                n.prev = null;
                self.first = n;
            } else {
                self.last = null;
                self.first = null;
            }
            self.len -= 1;
            return temp;
        }

        pub fn unshift(self: *Self, n: *Node) void {
            n.next = self.first;
            if (self.first) |f| {
                f.prev = n;
            } else {
                self.last = n;
            }
            self.len += 1;
            self.first = n;
        }

        pub fn delete(self: *Self, n: *Node) void {
            var temp: ?*Node = self.first;
            while (temp) |t| {
                if (t.data == n.data) {
                    if (t.prev) |tp| {
                        tp.*.next = t.next;
                    } else {
                        self.first = t.next;
                    }
                    if (t.next) |tn| {
                        tn.*.prev = t.prev;
                    } else {
                        self.last = t.prev;
                    }
                    self.len -= 1;
                    return;
                }
                temp = temp.?.*.next;
            }
        }
    };
}
