public type LinkedList record {
    Node? first;
    Node? last;
};

type Node record {
    int value;
    Node? next;
    Node? prev;
};

public function newLinkedList() returns LinkedList {
    return {first: (), last: ()};
}

# Adds a new value to the tail of a linked list
#
# + list - the linked list
# + value - integer value to add
public function push(LinkedList list, int value) {
    Node n = {value, next: (), prev: ()};
    if list.last is () {
        list.first = n;
        list.last = n;
        return;
    }

    if list.first === list.last {
        Node first = <Node>list.first;
        first.next = n;
    } else {
        Node last = <Node>list.last;
        last.next = n;
    }

    n.prev = list.last;
    list.last = n;
}

# Adds a new value to the head of a linked list
#
# + list - the linked list
# + value - integer value to add
public function unshift(LinkedList list, int value) {
    Node n = {value, next: (), prev: ()};
    if list.first is () {
        list.first = n;
        list.last = n;
        return;
    }

    if list.first === list.last {
        Node last = <Node>list.last;
        last.prev = n;
    } else {
        Node first = <Node>list.first;
        first.prev = n;
    }

    n.next = list.first;
    list.first = n;
}

# Remove a value from the tail of a linked list
#
# + list - the linked list
# + return - the value, or nil if the list is empty
public function pop(LinkedList list) returns int? {
    if list.last is () {
        return ();
    }
    Node n = <Node>list.last;

    list.last = n.prev;
    if list.last is () {
        list.first = ();
    } else {
        Node last = <Node>=list.last;
        last.next = ();
    }

    return n.value;
}

# Remove a value from the head of a linked list
#
# + list - the linked list
# + return - the value, or nil if the list is empty
public function shift(LinkedList list) returns int? {
    if list.first is () {
        return ();
    }
    Node n = <Node>list.first;

    list.first = n.next;
    if list.first is () {
        list.last = ();
    } else {
        Node first = <Node>list.first;
        first.prev = ();
    }

    return n.value;
}

# Count the number of values in a list
#
# + list - the linked list
# + return - the number of values, or zero for an empty list
public function count(LinkedList list) returns int {
    int result = 0;
    Node? n = list.first;
    while !(n is ()) {
        result += 1;
        n = n.next;
    }
    return result;
}

# Delete the given value from the linked list
#
# + list - the linked list
# + value - integer value to delete
public function delete(LinkedList list, int value) {
    Node? n = list.first;
    while !(n is ()) && n.value != value {
        n = n.next;
    }
    if !(n is ()) && n.value == value && list.first == n && list.last == n {
        list.first = ();
        list.last = ();
        return;
    }
    if !(n is ()) && n.value == value && list.first == n {
        list.first = n.next;
        return;
    }
    if !(n is ()) && n.value == value && list.last == n {
        Node prev = <Node>n.prev;
        prev.next = ();
        list.last = prev;
        return;
    }
    if !(n is ()) && !(n.prev is ()) && !(n.next is ()) && n.value == value {
        Node prev = <Node>n.prev;
        Node next = <Node>n.next;
        prev.next = n.next;
        next.prev = n.prev;
    }
}
