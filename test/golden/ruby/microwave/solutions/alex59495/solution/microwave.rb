=begin
Write your code for the 'Microwave' exercise in this file. Make the tests in
`microwave_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/microwave` directory.
=end

class Microwave
  attr_reader :second

  def initialize(second)
    @second = second
  end

  def timer
    min, sec = second.divmod(100)
    min += sec / 60
    sec %= 60
    "%02d:%02d" % [min, sec]
  end
end
