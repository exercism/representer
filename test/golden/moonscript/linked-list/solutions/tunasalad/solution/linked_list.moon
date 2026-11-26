class Node
  new: (value) => @value = value
  unlink: =>
    @prev\link @next
    @prev = nil
    @next = nil
  link: (new_next) =>
    @next = new_next
    new_next.prev = @
    
class LinkedList
  new: =>
    @head = Node nil
    @tail = Node nil
    @head\link @tail
    @len = 0

  push: (value) =>
    @len += 1
    n = Node value
    p = @tail.prev
    p\link n
    n\link @tail

  unshift: (value) =>
    @len += 1
    p = Node value
    n = @head.next
    p\link n
    @head\link p

  pop: =>
    assert @len > 0, 'pop from an empty list'
    @len -= 1
    n = @tail.prev
    n\unlink!
    n.value

  shift: =>
    assert @len > 0, 'shift from an empty list'
    @len -= 1
    n = @head.next
    n\unlink!
    n.value

  count: => @len

  delete: (value) =>
    n = @head.next
    while n != @tail
      if n.value == value
        @len -= 1
        n\unlink!
        break
      n = n.next
