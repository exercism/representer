module Squares
  extend self

  def square_of_sum(n)
    (1..n).sum ** 2
  end

  def sum_of_squares(n)
    (1..n).sum(&.**(2))
  end

  def difference_of_squares(n)
    square_of_sum(n) - sum_of_squares(n)
  end
end
