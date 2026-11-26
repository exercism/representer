public type LinkedList record {|
    int? value;
    LinkedList? next;
    LinkedList? prev;
|};

public function newLinkedList() returns LinkedList {
    LinkedList list = {next: (), prev: (), value: ()};
    return list;
}

# Adds a new value to the tail of a linked list
#
# + list - the linked list
# + value - integer value to add
public function push(LinkedList list, int value) {
    var newItem = of(value);
    var prev = list.prev;
    if prev is () {
        list.next = newItem;
        list.prev = newItem;
    } else {
        newItem.prev = prev;
        prev.next = newItem;
        list.prev = newItem;
    }
}

# Adds a new value to the head of a linked list
#
# + list - the linked list
# + value - integer value to add
public function unshift(LinkedList list, int value) {
    var newItem = of(value);
    var next = list.next;
    if next is () {
        list.next = newItem;
        list.prev = newItem;
    } else {
        newItem.next = next;
        next.prev = newItem;
        list.next = newItem;
    }
}

# Remove a value from the tail of a linked list
#
# + list - the linked list
# + return - the value, or nil if the list is empty
public function pop(LinkedList list) returns int? {
    var prev = list.prev;
    if prev is () {
        return ();
    }
    var prevPrev = prev.prev;
    if prevPrev !is () {
        prevPrev.next = ();
        list.prev = prevPrev;
    } else {
        list.next = ();
        list.prev = ();
    }
    return prev.value;
}

# Remove a value from the head of a linked list
#
# + list - the linked list
# + return - the value, or nil if the list is empty
public function shift(LinkedList list) returns int? {
    var next = list.next;
    if next is () {
        return ();
    }
    var nextNext = next.next;
    if nextNext !is () {
        nextNext.prev = ();
        list.next = nextNext;
    } else {
        list.next = ();
        list.prev = ();
    }
    return next.value;
}

# Count the number of values in a list
#
# + list - the linked list
# + return - the number of values, or zero for an empty list
public function count(LinkedList list) returns int {
    int count = 0;
    LinkedList? current = list.next;
    while current != () {
        current = current.next;
        count += 1;
    }
    return count;
}

# Delete the given value from the linked list
#
# + list - the linked list
# + value - integer value to delete
public function delete(LinkedList list, int value) {
    var current = list.next;
    while current != () {
        var prev = current.prev;
        var next = current.next;
        if current.value == value {
            if prev !is () {
                prev.next = next;
            } else {
                list.next = next;
            }
            if next !is () {
                next.prev = prev;
            } else {
                list.prev = prev;
            }
            return;
        }
        current = next;
    }
}

public function of(int value) returns LinkedList {
    var list = newLinkedList();
    list.value = value;
    return list;
}
