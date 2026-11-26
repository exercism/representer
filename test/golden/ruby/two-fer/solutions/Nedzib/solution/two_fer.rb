=begin
Write your code for the 'Two Fer' exercise in this file. Make the tests in
`two_fer_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/two-fer` directory.
=end

class TwoFer
    def initialize()
    end
    def two_fer(name = 'you')
        return "One for #{name}, one for me."
    end
end
TwoFer = TwoFer.new()

puts TwoFer.two_fer
