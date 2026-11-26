class Node
  getter value : Int32
  property left : Node | Nil = nil
  property right : Node | Nil = nil

  def initialize(@value)
  end

  def insert(value)
    new_node = Node.new(value)
    if value > @value
      right = @right
      if right.nil?
        @right = new_node
      else
        right.insert(value)
      end
    else
      left = @left
      if left.nil?
        @left = new_node
      else
        left.insert(value)
      end
    end
  end

  def sort
    in_order = Array(Int32).new()
    left = @left
    right = @right
    if !left.nil?
      in_order.concat(left.sort)
    end
    in_order.push(@value)
    if !right.nil?
      in_order.concat(right.sort)
    end
    in_order
  end
end
