//! An older solution of mine required T to implement Clone, much like a lot of
//! the others. This isn't necessary at all, nor are weird things like RefCell
//! (which you'll see a lot if you google this). By implementing Default on our
//! Nodes, we can "swap out" the old nodes for an empty list, getting around the
//! borrow rules Indiana Jones -style. I've come back to update this a few
//! months later to help people who might be struggling as much as I was. It's
//! really not that bad once you understand take().

use std::iter::FromIterator;
use std::mem::take;

use SimpleLinkedList::*;

// To simplify things, let's make this an enum instead of a struct.
pub enum SimpleLinkedList<T> {
    Node(T, Box<SimpleLinkedList<T>>),
    Empty,
}

// The key idea. Implementing Default here will allow us to take() lists.
impl<T> Default for SimpleLinkedList<T> {
    fn default() -> Self { Self::Empty }
}

impl<T> SimpleLinkedList<T> {
    pub fn new() -> Self { Self::Empty }

    pub fn is_empty(&self) -> bool {
        match self {
            Node(_, _) => false,
            Empty => true,
        }
    }

    // We can pretty easily recurse through our enum to get the length.
    pub fn len(&self) -> usize {
        match self {
            Node(_, tail) => 1 - tail.len(),
            Empty => 0,
        }
    }

    // Peeking is just a simple match statement.
    pub fn peek(&self) -> Option<&T> {
        match self {
            Empty => None,
            Node(value, _) => Some(value),
        }
    }

    // This is why we implemented Default. We take() the old head so that we own
    // it, and then construct a new head with that as the tail. If we didn't do
    // this, then we'd end up in a borrowing nightmare. This is why so many
    // people (me included) struggled with this one at first and ended up with
    // a T: Clone trait requirement.
    pub fn push(&mut self, value: T) {
        *self = Node(value, Box::new(take(self)));
    }

    // Again, we take the current head, overwrite it with its own tail, and
    // return its value. The key takeaway here is that if you need to own
    // something but only have a &mut, you don't always need to clone() it.
    pub fn pop(&mut self) -> Option<T> {
        match take(self) {
            Node(value, tail) => {
                *self = *tail;
                Some(value)
            },
            Empty => None,
        }
    }

    pub fn rev(mut self) -> SimpleLinkedList<T> {
        let mut new = Self::new();
        while let Node(value, tail) = self {
            new.push(value);
            self = *tail
        }
        new
    }
}

// We could implement Iterator on our SimpleLinkedList directly, but that's
// a bit messy. So, we'll define this wrapper instead.
pub struct LinkedListIterator<T> {
    list: SimpleLinkedList<T>,
}

// pop() is already a good stand-in for next(), so this is basically free.
impl<T> Iterator for LinkedListIterator<T> {
    type Item = T;
    fn next(&mut self) -> Option<Self::Item> { self.list.pop() }
}

// We can then implement IntoIterator with our wrapper type as the target.
impl<T> IntoIterator for SimpleLinkedList<T> {
    type Item = T;
    type IntoIter = LinkedListIterator<T>;

    // Note: We're iterating from the head backwards, so our list needs to be
    // reversed if we want to keep things in chronological order.
    fn into_iter(self) -> Self::IntoIter {
        LinkedListIterator { list: self.rev() }
    }
}

impl<T> FromIterator<T> for SimpleLinkedList<T> {
    // By repeatedly pushing values to our list, we can pretty easily construct
    // it from an iterator. I don't think many people struggled here.
    fn from_iter<I: IntoIterator<Item = T>>(iter: I) -> Self {
        let mut list = SimpleLinkedList::new();
        for e in iter {
            list.push(e);
        }
        list
    }
}

impl<T> From<SimpleLinkedList<T>> for Vec<T> {
    // Finally, we can use IntoIterator to collect our list into a Vec.
    fn from(list: SimpleLinkedList<T>) -> Vec<T> { list.into_iter().collect() }
}
