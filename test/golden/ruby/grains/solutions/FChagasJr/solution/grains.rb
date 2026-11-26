=begin
Write your code for the 'Grains' exercise in this file. Make the tests in
`grains_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/grains` directory.
=end

class Grains

  def self.square(sqr)
    raise ArgumentError unless sqr.between?(1,64)
    2 ** (sqr - 1)
  end

  def self.total
    1.upto(64).inject{|sum,sqr| sum + self.square(sqr)}
  end

end
  