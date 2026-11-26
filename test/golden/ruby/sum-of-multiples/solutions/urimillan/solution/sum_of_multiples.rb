class SumOfMultiples
  def initialize(*multiples)
    @multiples = multiples
  end

  def to(num)
    (1...num).select { |i| @multiples.any? { |multiple| i % multiple == 0 }}.sum
  end
end