module Squares
  extend self

  def square_of_sum(num)
    (1..num).sum ** 2
  end

  def sum_of_squares(num)
    (1..num).sum(&.** 2)
  end

  def difference_of_squares(num)
    square_of_sum(num) - sum_of_squares(num)
  end
end
