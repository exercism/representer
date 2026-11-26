=begin
Write your code for the 'Clock' exercise in this file. Make the tests in
`clock_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/clock` directory.
=end
class Clock
  include Comparable
  attr_reader :hour, :minute
  def initialize(hour: 0, minute: 0)
    h, @minute = minute.divmod(60)
    @hour = (hour + h) % 24
  end
  def +(other)
    self.class.new(hour: @hour + other.hour, minute: @minute + other.minute)
  end
  def -(other)
    self.class.new(hour: @hour - other.hour, minute: @minute - other.minute)
  end
  def <=>(other)
    [@hour,@minute] <=> [other.hour, other.minute]
  end
  def to_s
    '%02i:%02i' %  [@hour,  @minute]
  end
end