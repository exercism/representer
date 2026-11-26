// ---------------------------------------------------------------------------
// exercism.org
// V Track Exercise: linked-list
// Contributed: Anthony J. Borla (ajborla@bigpond.com)
// ---------------------------------------------------------------------------

module main

struct Node {
mut:
   data int
   prev &Node = unsafe { nil }
   next &Node = unsafe { nil } 
}

struct LinkedList {
mut:
   first &Node = unsafe { nil } 
   last &Node = unsafe { nil } 
}

pub fn (mut l LinkedList) push(value int) {
   mut node := &Node{ data : value } 
   unsafe {
      if l.first == nil {
         l.first = node
         l.last = node
      }
      else {
         l.last.next = node
         node.prev = l.last
         l.last = node
      }
   }
}

pub fn (mut l LinkedList) pop() int {
   unsafe {
      data := l.last.data
      if l.first != l.last {
         l.last = l.last.prev
         l.last.next = nil
      }
      else {
         l.first = nil
         l.last = l.first
      }
      return data
   }
}

pub fn (mut l LinkedList) unshift(value int) {
   mut node := &Node{ data : value }
   unsafe {
      if l.first == nil {
         l.first = node
         l.last = node
      }
      else {
         l.first.prev = node
         node.next = l.first
         l.first = node
      }
   }
}

pub fn (mut l LinkedList) shift() int {
   unsafe {
      data := l.first.data
      if l.first != l.last {
         l.first = l.first.next 
         l.first.prev = nil
      }
      else {
         l.last = nil
         l.first = l.last 
      }
      return data
   }
}

pub fn (l LinkedList) count() int {
   mut node_count := 0
   unsafe {
      mut node := l.first
      for node != nil {
          node_count += 1
          node = node.next
      }
   }
   return node_count
}

pub fn (mut l LinkedList) delete(value int) {   
   unsafe {
      if l.first == nil { return }
      mut node := l.first
      for node != nil {
          if node.data == value {
             if l.first != l.last {
                if node == l.first { l.first = node.next }
                if node != l.last { l.last = node.prev }
                if node.prev != nil { node.prev.next = node.next }
                if node.next != nil { node.next.prev = node.prev }
             } 
             else {
                l.last = nil
                l.first = l.last
             }
             return
          }
          node = node.next
      }
   }
   return
}
