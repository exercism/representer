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

        pub fn push(self: *Self, new: *Node) void {
            if (self.last) |node| {
                node.next = new;
                new.prev = node; 
            } else self.first = new; 
            self.last = new;
            self.len += 1;    
        }

        pub fn pop(self: *Self) ?*Node {
            if (self.last) |node| {
                self.last = node.prev;
                self.len -= 1;
                return node;
            } else return null;
        }

        pub fn shift(self: *Self) ?*Node {
            if (self.first) |node| {
                self.first = node.next;
                if (node.next != null) self.last = null;
                self.len -= 1;
                return node;
            } else return null;
        }

        pub fn unshift(self: *Self, new: *Node) void {
            if (self.first) |oldfirst| {
                new.next = oldfirst;
                oldfirst.prev = new;
            }
            else self.last = new;
            self.first = new;
            self.len += 1;
        }

        pub fn delete(self: *Self, this: *Node) void {
            var current = self.first;
            while (current) |c| : (current = c.next) {
                if (c != this) continue;
                const previous = c.prev;
                const next = c.next;
                if (previous) |pr| {
                    pr.next = next;
                    if (next == null) self.last = pr;
                }
                if (next) |ne| {
                    ne.prev = previous;
                    if (previous == null) self.first = ne;
                }
                self.len -= 1;
            }
        }
    };
}
