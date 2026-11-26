pub fn LinkedList(comptime T: type) type {
    return struct {
        pub const Node = struct {
            prev: ?*Node = null,
            next: ?*Node = null,
            data: T,
        };
        head: ?*Node = null,
        tail: ?*Node = null,
        len: usize = 0,

        pub fn push(self: *@This(), node: *Node) void {
            if (self.tail) |tail| {
                tail.next = node;
                node.prev = tail;
            } else self.head = node;
            self.tail = node;
            self.len += 1;
        }

        pub fn pop(self: *@This()) ?*Node {
            const tail = self.tail orelse return null;
            if (tail == self.head) self.head = null;
            self.tail = tail.prev;
            self.len -= 1;
            return tail;
        }

        pub fn shift(self: *@This()) ?*Node {
            const head = self.head orelse return null;
            if (head == self.tail) self.tail = null;
            self.head = head.next;
            self.len -= 1;
            return head;
        }

        pub fn unshift(self: *@This(), node: *Node) void {
            if (self.head) |head| {
                head.prev = node;
                node.next = head;
            } else {
                self.tail = node;
            }
            self.head = node;
            self.len += 1;
        }

        pub fn delete(self: *@This(), node: *Node) void {
            var xs = self.head;
            while (xs) |x| : (xs = x.next) {
                if (x != node) continue;
                if (x == self.head) self.head = x.next;
                if (x.prev) |p| p.next = x.next;
                if (x.next) |n| n.prev = x.prev;
                if (x == self.tail) self.tail = x.prev;
                self.len -= 1;
                return;
            }
        }
    };
}
