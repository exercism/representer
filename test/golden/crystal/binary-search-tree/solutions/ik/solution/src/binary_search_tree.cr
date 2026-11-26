class Node
  getter value
  getter left : Node?
  getter right : Node?

  def initialize(@value : Int32) end

  def insert(value : Int32)
    if value > @value
      if @right
        @right.as(Node).insert(value)
      else
        @right = self.class.new(value)
      end
    else
      if @left
        @left.as(Node).insert(value)
      else
        @left = self.class.new(value)
      end
    end
  end

  def sort : Array(Int32)
    [
      *(@left ? @left.as(Node).sort : [] of Int32),
      value,
      *(@right ? @right.as(Node).sort : [] of Int32),
    ]
  end
end
