class Triangle
  getter sides : Array(Int32) | Array(Float64)

  def initialize(sides)
    @sides = sides.to_a

    if sides.any? &.zero?
      raise ArgumentError.new("all triangle side could not be zero")
    end

    sorted_sides = @sides.sort
    if sorted_sides.first(2).sum < sorted_sides.last
      raise ArgumentError.new("violate triangle inequality")
    end
  end

  def equilateral?
    sides.uniq.size == 1
  end

  def isosceles?
    sides.uniq.size <= 2
  end

  def scalene?
    sides.uniq.size == 3
  end
end