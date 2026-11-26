=begin
Write your code for the 'Collatz Conjecture' exercise in this file. Make the tests in
`collatz_conjecture_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/collatz-conjecture` directory.
=end

class CollatzConjecture

  def self.steps(num)
    raise ArgumentError unless num.positive?
    
    counter = 0
     while num != 1
      num = num.even? ? num/2 : 3*num + 1
      counter += 1
    end
  counter
  end
end