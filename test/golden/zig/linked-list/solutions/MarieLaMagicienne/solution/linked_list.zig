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

        pub fn push(self: *Self, n: *Node) void {
            if (self.len == 0) {
                self.first = n;
                self.last = n;
                n.next = null;
                n.prev = null;
            } else {
                if (self.last) |v| v.next = n;
                n.prev = self.last;
                self.last = n;
                n.next = null;
            }
            self.len += 1;
        }

        pub fn pop(self: *Self) ?*Node {
            if (self.len == 0) return null;
            var result = self.last;
            if (self.len == 1) {
                self.first = null;
                self.last = null;
            } else {
                if (result) |r| {
                    self.last = r.prev;
                } else {
                    self.last = null;
                }
                if (self.last) |v| v.next = null;
            }
            self.len -= 1;
            if (result) |r| {
                r.next = null;
                r.prev = null;
            }
            return result;
        }

        pub fn shift(self: *Self) ?*Node {
            if (self.len == 0) return null;

            var result = self.first;
            if (self.len == 1) {
                self.first = null;
                self.last = null;
            } else {
                if (result) |r| self.first = r.next;
                if (self.first) |v| v.prev = null;
            }

            self.len -= 1;
            if (result) |r| {
                r.next = null;
                r.prev = null;
            }
            return result;
        }

        pub fn unshift(self: *Self, n: *Node) void {
            if (self.len == 0) {
                self.first = n;
                self.last = n;
                n.next = null;
                n.prev = null;
            } else {
                if (self.first) |v| v.prev = n;
                n.next = self.first;
                self.first = n;
                n.prev = null;
            }
            self.len += 1;
        }

        fn checkIfContains(self: *Self, n: *Node) bool {
            var pointer = self.first;
            while (true) {
                if (pointer) |value| {
                    if (value == n) {
                        return true;
                    } else {
                        pointer = value.next;
                    }
                } else return false;
            }
            return false;
        }

        pub fn delete(self: *Self, n: *Node) void {
            if (!self.checkIfContains(n)) {
                return;
            }
            if (n.prev) |v| {
                v.next = n.next;
            } else {
                self.first = n.next;
            }

            if (n.next) |v| {
                v.prev = n.prev;
            } else {
                self.last = n.prev;
            }
            self.len -= 1;
        }
    };
}
