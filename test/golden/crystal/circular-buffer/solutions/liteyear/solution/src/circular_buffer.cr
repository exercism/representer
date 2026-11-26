class CircularBuffer
  @buf : Array(Int32)
  @size : Int32
  @is_full : Bool
  @head : Int32
  @tail : Int32

  def initialize(size)
    @buf = Array.new(size, 0)
    @size = size
    @head = 0
    @tail = 0
    @is_full = false
  end

  def is_empty?
    !@is_full && @head == @tail
  end

  def write(val)
    if @is_full
      raise RuntimeError.new
    end

    @buf[@tail] = val
    @tail = (@tail + 1) % @size
    @is_full = @tail == @head
  end

  def overwrite(val)
    if @is_full
      read
    end
    write(val)
  end

  def read
    if is_empty?
      raise RuntimeError.new
    end

    old_head = @head
    @head = (@head + 1) % @size
    @is_full = false
    @buf[old_head]
  end

  def clear
    @head = @tail
    @is_full = false
  end
end
