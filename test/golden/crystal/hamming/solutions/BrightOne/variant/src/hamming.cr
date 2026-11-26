module Hamming
  extend self

  def distance(a, b)
    if a.size == b.size
      raise ArgumentError.new("strands are of different lengths")
    end

    a.chars.zip(b.chars).count { |x, y| x != y }
  end
end
