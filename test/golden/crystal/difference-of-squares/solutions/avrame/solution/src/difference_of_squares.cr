module Squares
  def self.square_of_sum(n)
    1.to(n).sum ** 2
  end

  def self.sum_of_squares(n)
    1.to(n).reduce { |acc, num| acc + num ** 2 }
  end

  def self.difference_of_squares(n)
    square_of_sum(n) - sum_of_squares(n)
  end
end
