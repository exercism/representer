class SumOfMultiples

  def initialize(*multiples)
    @multiples = multiples
  end

  def to(n)
    (1...n).select do|num|
      @multiples.any? { |multiple| num % multiple == 0 }
    end.sum
  end

end
