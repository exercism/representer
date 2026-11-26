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

        pub fn push(self: *LinkedList(T), elt: *Node) void {
            // Please implement this method.
            
            if (self.last == null) {
                self.last = elt;
                self.first = elt;
                self.len  = 1;
            } else {
                var prev = self.last.?;
                prev.next = elt;
                elt.prev = prev;
                elt.next = null;
                self.last = elt;
                
                self.len = self.len + 1;
            }
        }

        pub fn pop(self: *LinkedList(T)) ?*Node {
            // Please implement this method.
            // It must return an optional pointer to a Node.
            if (self.last == null) {
                return null;
            } else {
                var last = self.last.?;
                self.last = last.prev;
                if (self.last == null) {
                    self.first = null;
                }
                self.len = self.len - 1;
                return last;
            }
        }

        pub fn shift(self: *LinkedList(T)) ?*Node {
            if (self.first == null) {
                return null;
            } else {
                var first = self.first.?;
                self.first = first.next;
                if (self.first == null) {
                    self.last = null;
                }
                self.len = self.len - 1;
                return first;
            }
        }

        pub fn unshift(self: *LinkedList(T), elt: *Node) void {
            if (self.first == null) {
                self.last = elt;
                self.first = elt;
                self.len  = 1;
            } else {
                var first = self.first.?;
                first.prev = elt;
                elt.prev = null;
                elt.next = first;
                self.first = elt;
                
                self.len = self.len + 1;
            }
        }

        pub fn delete(self: *LinkedList(T), elt: *Node) void {
            // Please implement this method.
            // It must modify the list only when it contains the given node.
            var cnode = self.first;
            while (cnode != null) {
                if (cnode == elt) {
                    if (cnode.?.next != null) {
                        cnode.?.next.?.prev = cnode.?.prev;
                    }
                    if (cnode.?.prev != null) {
                        cnode.?.prev.?.next = cnode.?.next;
                    }
                    if (cnode.?.prev == null) {
                        self.first = cnode.?.next;
                    }
                    if (cnode.?.next == null) {
                        self.last = cnode.?.prev;
                    }
                    self.len = self.len - 1;
                    return;
                } else {
                    cnode = cnode.?.next;
                }
            }
         
        }
    };
}
