=begin
Write your code for the 'Raindrops' exercise in this file. Make the tests in
`raindrops_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/raindrops` directory.
=end

class Raindrops

  def self.convert(num)
    string = ''
    if num % 3 == 0 or num % 5 == 0 or num % 7 == 0
    if num % 3 == 0
      string += 'Pling'
    end
    if num % 5 == 0
      string = string + 'Plang'
    end
    if num % 7 ==0
      string += 'Plong'
    end
    else
    string += num.to_s
    end
    
    string
  end
end