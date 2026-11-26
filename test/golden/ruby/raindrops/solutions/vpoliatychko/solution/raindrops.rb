=begin
Write your code for the 'Raindrops' exercise in this file. Make the tests in
`raindrops_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/raindrops` directory.
=end
module Raindrops
    def self.convert(num)
        rules = {3 => "Pling", 5 => "Plang", 7 => "Plong"}
        answer = rules.map{|x, s| num % x == 0 ? s : ''}.join
        !answer.empty? ? answer : num.to_s
    end
end