=begin
Write your code for the 'Collatz Conjecture' exercise in this file. Make the tests in
`collatz_conjecture_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/collatz-conjecture` directory.
=end

class CollatzConjecture
  def self.steps(num)
    step = 0
    if (num <= 0) 
      raise ArgumentError
    end
    while (num > 1)
      step+=1
      if (num % 2 == 0)
        num = num/2
      else
        num = num*3 + 1
      end
    end

    return step
  end
end