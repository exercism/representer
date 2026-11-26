class Node
  property value
  property left
  property right
  @left : Node? = nil
  @right : Node? = nil

  def initialize(@value : Int32) end

  def insert(value : Int32)
    if value <= @value
      left = @left
      if left.is_a?(Node)
        left.insert(value)
      else
        @left = Node.new(value)
      end
    else
      right = @right
      if right.is_a?(Node)
        right.insert(value)
      else
        @right = Node.new(value)
      end
    end
  end

  def sort
    left = @left
    right = @right
    result = [] of Int32
    result.concat(left.sort) if left.is_a?(Node)
    result.push(@value)
    result.concat(right.sort) if right.is_a?(Node)
    result
  end
end
