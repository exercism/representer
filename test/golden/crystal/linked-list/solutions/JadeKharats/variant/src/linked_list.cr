class LinkedList
  class Node
    getter value : Int32
    property next : Node?
    property prev : Node?

    def initialize(@value, @next = nil, @prev = nil)
    end
  end

  getter head : Node? = nil
  getter tail : Node? = nil

  def initialize
  end

  def count
    result = 0

    each_node { result += 1 }

    result
  end

  def delete(val)
    each_node do |node|
      next unless node.value == val

      case node
      when head
        shift
      when tail
        if prev = node.prev
          prev.next = node.next
        end
        pop
      else
        if prev = node.prev
          prev.next = node.next
        end
        if next_node = node.next
          next_node.prev = node.prev
        end
      end

      break
    end
  end

  def each_node(&)
    curr = head

    while curr
      yield curr
      curr = curr.next
    end
  end

  def push(val)
    node = Node.new(val, prev: tail)

    if node_tail = tail
      node_tail.next = node
    end
    @head = node unless head
    @tail = node
  end

  def pop
    if node_tail = tail
      node_tail.value.tap do
        @head = nil if head == node_tail
        @tail = node_tail.prev
      end
    end
  end

  def shift
    if node_head = head
      node_head.value.tap do
        @tail = nil if tail != node_head
        @head = node_head.next
      end
    end
  end

  def unshift(val)
    node = Node.new(val, next: head)

    if node_head = head
      node_head.prev = node
    end
    @tail = node unless tail
    @head = node
  end
end
