class CircularBuffer
  @buffer : Array(Int32 | Nil)
  @read_pos = 0
  @write_pos = 0
  @length = 0
  @element_count = 0

  def initialize(length : Int32)
    @length = length
    @buffer = Array(Int32 | Nil).new(@length) { nil }
  end

  def empty? : Bool
    @element_count == 0
  end

  def full? : Bool
    @element_count == @length
  end

  def read : Int32
    raise RuntimeError.new("Empty buffer") if empty?

    value = @buffer[@read_pos]
    if value.nil?
      raise "Got nil value from buffer"
    end
    @buffer[@read_pos] = nil
    @read_pos = next_element(@read_pos)
    @element_count -= 1
    value
  end

  def write(value : Int32) : Nil
    raise RuntimeError.new("Buffer full") if full?

    @buffer[@write_pos] = value
    @write_pos = next_element(@write_pos)
    @element_count += 1
  end

  def clear : Nil
    @read_pos = 0
    @write_pos = 0
    @element_count = 0
    @buffer.fill(nil)
  end

  def overwrite(value : Int32) : Nil
    read if full?
    write(value)
  end

  def next_element(position : Int32) : Int32
    (position + 1) % @length
  end
end
