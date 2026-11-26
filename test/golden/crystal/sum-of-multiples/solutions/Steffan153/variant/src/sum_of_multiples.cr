module SumOfMultiples
  extend self

  def sum(multiples, num)
    (1...num).to_a.select { |x| multiples.any? { |y| x % y != 0 rescue false } }.sum
  end
end
