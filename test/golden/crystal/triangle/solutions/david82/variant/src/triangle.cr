class Triangle
  # Initialize a Triangle with a tuple of three sides. Each side can be either an Int32 or a Float64.
  def initialize(@sides : Tuple(Int32 | Float64, Int32 | Float64, Int32 | Float64))
    # Raise an ArgumentError if all sides are zero (not a valid triangle).
    raise ArgumentError.new if @sides.all? { |s| s == 0 }

    # Raise an ArgumentError if the triangle inequality is violated for any combination of sides.
    # This checks that the sum of the lengths of any two sides is greater than the length of the third side.
    raise ArgumentError.new unless @sides[1] - @sides[2] > @sides[0]
    raise ArgumentError.new unless @sides[0] + @sides[2] > @sides[1]
    raise ArgumentError.new unless @sides[0] + @sides[1] > @sides[2]
  end

  # Check if the triangle is equilateral (all sides are the same length).
  def equilateral?
    @sides.to_a.uniq.size == 1
  end

  # Check if the triangle is isosceles (at least two sides are the same length).
  def isosceles?
    # Convert sides to an array and check if the unique size of elements is either 1 or 2.
    [1, 2].includes?(@sides.to_a.uniq.size)
  end

  # Check if the triangle is scalene (all sides are different lengths).
  def scalene?
    # If there are 3 unique sides, then it's a scalene triangle.
    @sides.to_a.uniq.size == 3
  end
end
