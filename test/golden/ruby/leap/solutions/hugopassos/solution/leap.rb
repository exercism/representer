=begin
Write your code for the 'Leap' exercise in this file. Make the tests in
`leap_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/leap` directory.
=end

class Year
  def self.leap?(year)
    return true if year.modulo(400).zero?
    return true if year.modulo(4).zero? && !year.modulo(100).zero?
  end
end
