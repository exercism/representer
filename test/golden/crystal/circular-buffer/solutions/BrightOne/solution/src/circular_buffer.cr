class CircularBuffer
  def initialize(capacity : UInt32)
    @capacity = capacity
    @buffer = [] of Int32
  end

  def read
    @buffer.shift? || raise RuntimeError.new("empty buffer")
  end

  def write(elem : Int32)
    raise RuntimeError.new("full buffer") if full?

    overwrite(elem)
  end

  def overwrite(elem : Int32)
    read if full?

    @buffer << elem
  end

  def clear
    @buffer.clear
  end

  private def full?
    @buffer.size == @capacity
  end
end
