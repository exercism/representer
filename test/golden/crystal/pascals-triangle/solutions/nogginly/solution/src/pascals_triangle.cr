# Please implement your solution to pascals-triangle in this file
class PascalsTriangle
  # Call with n >= 1
  private def self.produce(n)
    return [[1]] if n == 1

    triangle = produce(n - 1)
    prev = triangle.last
    row = [1]
    prev.each_cons_pair do |a, b|
      row << a + b
    end
    triangle << (row << 1)
  end

  def self.rows(n)
    return [] of Int32 if n.zero? || n.negative?
    produce(n) # if n >= 1
  end
end
