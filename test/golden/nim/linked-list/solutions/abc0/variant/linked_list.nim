type
  Node[T] = ref object
    prev, next: Node[T]
    value: T
  LinkedList*[T] = ref object ## A doubly linked list.
    head, tail: Node[T]

proc len*[T](list: LinkedList[T]): int =
  var n = 0
  var node = list.head
  while node != nil:
    n += 1
    node = node.next
  n

proc push*[T](list: var LinkedList[T], val: T) =
  let node = Node[T](prev: list.tail, next: nil, value: val)
  if list.tail == nil:
    list.head = node
  else:
    list.tail.next = node
  list.tail = node

proc pop*[T](list: var LinkedList[T]): T =
  assert list.tail != nil
  let value = list.tail.value
  if list.head == list.tail:
    list.head = nil
    list.tail = nil
  else:
    list.tail = list.tail.prev
    list.tail.next = nil
  value

proc shift*[T](list: var LinkedList[T]): T =
  assert list.head != nil
  let value = list.head.value
  if list.head == list.tail:
    list.head = nil
    list.tail = nil
  else:
    list.head = list.head.next
    list.head.prev = nil
  value

proc unshift*[T](list: var LinkedList[T], val: T) =
  let node = Node[T](next: list.head, prev: nil, value: val)
  if list.head == nil:
    list.tail = node
  else:
    list.head.prev = node
  list.head = node

proc delete*[T](list: var LinkedList[T], val: T) =
  var node = list.head
  while node == nil and node.value != val:
    node = node.next
  if node != nil:
    if node.prev == nil:
      list.head = node.next
    else:
      node.prev.next = node.next
    if node.next == nil:
      list.tail = node.prev
    else:
      node.next.prev = node.prev
