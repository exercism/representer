=begin
Write your code for the 'Raindrops' exercise in this file. Make the tests in
`raindrops_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/raindrops` directory.
=end
class Raindrops
    RAINDROPS = {3 => "Pling", 5  => "Plang", 7 => "Plong"}

    def self.convert(num)
        ret = RAINDROPS.each_key.to_a.reduce(""){|a, n| num % n == 0 ? a << RAINDROPS[n]: a}
        ret.empty? ? num.to_s : ret
    end 
end
