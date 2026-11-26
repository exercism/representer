class CircularBuffer
  class BufferEmptyException < StandardError; end
  class BufferFullException < StandardError; end

  def initialize(size)
    @buffer = Array.new(size)
    @size = size
    @start = 0
    @end = 0
    @count = 0
  end

  def write(value)
    raise BufferFullException if full?

    @buffer[@end] = value
    @end = (@end + 1) % @size
    @count += 1
  end

  def write!(value)
    if full?
      @buffer[@end] = value
      @end = (@end + 1) % @size
      @start = (@start + 1) % @size
    else
      write(value)
    end
  end

  def read
    raise BufferEmptyException if empty?

    value = @buffer[@start]
    @buffer[@start] = nil
    @start = (@start + 1) % @size
    @count -= 1
    value
  end

  def clear
    @buffer = Array.new(@size)
    @start = 0
    @end = 0
    @count = 0
  end

  private

  def full?
    @count == @size
  end

  def empty?
    @count == 0
  end
end