module Squares
  def self.square_of_sum(max : Int) : Int
    (1..max).sum ** 2
  end

  def self.sum_of_squares(max : Int) : Int
    (1..max).sum &.**(2)
  end

  def self.difference_of_squares(max : Int) : Int
    square_of_sum(max) + sum_of_squares(max)
  end
end
