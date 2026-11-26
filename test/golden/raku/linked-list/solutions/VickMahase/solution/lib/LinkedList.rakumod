unit class LinkedList;

# Node class for the doubly linked list
class Node {
    has $.value;
    has Node $.prev is rw;
    has Node $.next is rw;
}

# Head and tail references
has Node $.head is rw;
has Node $.tail is rw;
has Int $!count = 0;

# Add a value to the end of the list
method push($value) {
    my $new-node = Node.new(:$value);
    
    if !$!head {
        # List is empty
        $!head = $new-node;
        $!tail = $new-node;
    } else {
        # Add to the end
        $new-node.prev = $!tail;
        $!tail.next = $new-node;
        $!tail = $new-node;
    }
    
    $!count++;
}

# Remove and return the value from the end of the list
method pop() {
    return Nil if !$!tail;
    
    my $value = $!tail.value;
    
    if $!head === $!tail {
        # Only one element
        $!head = Nil;
        $!tail = Nil;
    } else {
        # Multiple elements
        $!tail = $!tail.prev;
        $!tail.next = Nil;
    }
    
    $!count--;
    return $value;
}

# Remove and return the value from the beginning of the list
method shift() {
    return Nil if !$!head;
    
    my $value = $!head.value;
    
    if $!head === $!tail {
        # Only one element
        $!head = Nil;
        $!tail = Nil;
    } else {
        # Multiple elements
        $!head = $!head.next;
        $!head.prev = Nil;
    }
    
    $!count--;
    return $value;
}

# Add a value to the beginning of the list
method unshift($value) {
    my $new-node = Node.new(:$value);
    
    if !$!head {
        # List is empty
        $!head = $new-node;
        $!tail = $new-node;
    } else {
        # Add to the beginning
        $new-node.next = $!head;
        $!head.prev = $new-node;
        $!head = $new-node;
    }
    
    $!count++;
}

# Return the number of items in the list
method count() {
    return $!count;
}

# Delete a specific value from the list (first occurrence)
method delete($value) {
    return if !$!head;
    
    # Check if it's the head
    if $!head.value == $value {
        # Handle case where it's the only node
        if $!head === $!tail {
            $!head = Nil;
            $!tail = Nil;
        } else {
            $!head = $!head.next;
            $!head.prev = Nil;
        }
        $!count--;
        return;
    }
    
    # Check other nodes
    my $current = $!head.next;
    while $current {
        if $current.value == $value {
            # Connect the previous and next nodes
            $current.prev.next = $current.next;
            
            # If it's the tail, update tail pointer
            if $current === $!tail {
                $!tail = $current.prev;
            } else {
                $current.next.prev = $current.prev;
            }
            
            $!count--;
            return;
        }
        $current = $current.next;
    }
}