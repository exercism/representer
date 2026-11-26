class Array
  def accumulate
    Array.new(size) { |i| yield(self[i]) }
  end
end

module BookKeeping
  VERSION = 2
end