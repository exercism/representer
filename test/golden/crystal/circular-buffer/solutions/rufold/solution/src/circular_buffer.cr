class CircularBuffer
  @head : UInt32
  @tail : UInt32
  @count : UInt32

  def initialize(@capacity : UInt32)
    @buffer = Array(Int32).new(capacity, 0)
    @count = @head = @tail = 0
  end

  def read
    raise RuntimeError.new if @count == 0
    value = @buffer[@tail]
    @tail = (@tail + 1) % @capacity
    @count -= 1
    value
  end

  def write(value : Int32)
    raise RuntimeError.new if @count >= @capacity
    overwrite(value)
  end

  def overwrite(value : Int32)
    @buffer[@head] = value
    @head = (@head + 1) % @capacity
    if @count == @capacity
      @tail = @head
    else
      @count += 1
    end
  end

  def clear
    @count = @head = @tail = 0
  end
end
