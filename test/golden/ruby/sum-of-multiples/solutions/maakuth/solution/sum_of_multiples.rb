=begin
Write your code for the 'Sum Of Multiples' exercise in this file. Make the tests in
`sum_of_multiples_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/sum-of-multiples` directory.
=end
class SumOfMultiples
  def initialize(*numbers)
    @numbers = numbers
  end

  def to(x)
    multiples = []
    (1..x-1).each do |i|
      multiples << i if @numbers.any?{|number| i % number == 0} && !multiples.include?(i)
    end
    multiples.reduce(:+) || 0
  end
end