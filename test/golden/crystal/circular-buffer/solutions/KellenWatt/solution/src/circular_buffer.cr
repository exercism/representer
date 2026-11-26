class CircularBuffer
  def initialize(size)
    @data = Array(Int32).new(size, 0)
    @size = 0
    @ptr = 0
  end

  def read
    raise RuntimeError.new("can't read empty buffer") if @size.zero?

    res = @data[@ptr]
    @size -= 1
    shift_ptr
    res
  end

  def write(value)
    raise RuntimeError.new("can't write to full buffer") if @size == @data.size

    idx = (@ptr + @size) % @data.size
    @data[idx] = value
    @size += 1
  end

  def overwrite(value)
    if @size < @data.size
      write(value)
    else
      @data[@ptr] = value
      shift_ptr
    end
  end

  def clear
    @size = 0
    @ptr = 0
  end

  private def shift_ptr
    @ptr = (@ptr + 1) % @data.size
  end

end
