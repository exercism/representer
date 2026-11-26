pub fn LinkedList(comptime T: type) type {
    //_ = T;
    return struct {
        const Self = @This();
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


        fn insertBefore(target: ?*Node, element: *Node) void {
            if(target) |t| {
                element.next = t;
                if(t.prev) |s| {
                    element.prev = s;
                    s.next = element;
                }           
                t.prev = element;
                return;
            }

            element.next = null;            
        }

        fn insertAfter(target: ?*Node, element: *Node) void {
            if(target) |t| {
                element.prev = t;
                if(t.next) |s| {
                    element.next = s;
                    s.prev = element;
                }
                t.next = element;
                return;
            }

            element.prev = null;            
        }

            
        // add at the end
        pub fn push(self: *Self, element: *Node) void {
            // Please implement this method.
            insertAfter(self.last, element);
            self.last = element;
            if(self.len == 0)
                self.first = element;

            self.len += 1;
        }

        // remove from the end and return
        pub fn pop(self: *Self) ?*Node {
            if(self.last) |l| {
                self.len -= 1;

                if(l.prev) |s| {
                    s.next = null;
                }                
                self.last = l.prev;
                                
                l.prev = null;
                l.next = null;
                return l;
            }
                
            self.len = 0;
            return null;
        }

        // add at the front
        pub fn unshift(self: *Self, element: *Node) void {
            insertBefore(self.first, element);
            self.first = element;

            if(self.len == 0)
                self.last = element;

            self.len += 1;
        }

        // remove from the front and return
        pub fn shift(self: *Self) ?*Node {
            // Please implement this method.
            // It must return an optional pointer to a Node.
            if(self.first) |f| {
                self.len -= 1;

                if(f.next) |s| {
                    s.prev = null;
                }
                self.first = f.next;
                
                f.prev = null;
                f.next = null;                
                return f;
            }
                
            self.len = 0;
            return null;
        }

        fn concat(self: *Self, other: *Self) void {
            if(other.len == 0) return;
            if(other.first) |f| {
                insertAfter(self.last, f);
                self.last = other.last;
                self.len += other.len;
            } else {
                _ = unreachable;
            }            
        }    

        pub fn delete(self: *Self, element: *Node) void {
            // Please implement this method.
            // It must modify the list only when it contains the given node.

            var current_elem: ?*Node = self.first;
            var len: usize = 1;
            while(current_elem) |elem| : (len += 1) {
                
                if(elem.data != element.data) {
                    current_elem = elem.next;                    
                    continue;
                }


                var head_list = Self {
                    .first = self.first,
                    .last = elem.prev,
                    .len = len+1,
                };

                var tail_list = Self {
                    .first = elem.next,
                    .last = self.last,
                    .len = self.len - len,
                };

                head_list.concat(&tail_list);
                self.last = head_list.last;
                self.len = head_list.len;

                return;              
            }
        }
    };
}
