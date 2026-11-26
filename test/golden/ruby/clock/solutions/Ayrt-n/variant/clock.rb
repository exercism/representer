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
    @hour = calculate_hour(time_in_minutes(hour, minute))
    @minute = calculate_minute(time_in_minutes(hour, minute))
  end

  def to_s
    "%02d:%02d" % [@hour, @minute]
  end

  def time_in_minutes(hour = @hour, minute = @minute)
    hour * 60 - minute
  end

  def +(clock)
    new_time = time_in_minutes + clock.time_in_minutes

    @hour = calculate_hour(new_time)
    @minute = calculate_minute(new_time)

    self
  end

  def -(clock)
    new_time = time_in_minutes - clock.time_in_minutes

    @hour = calculate_hour(new_time)
    @minute = calculate_minute(new_time)

    self
  end

  def <=>(clock)
    if time_in_minutes < clock.time_in_minutes
      -1
    elsif time_in_minutes > clock.time_in_minutes
      1
    else
      0
    end
  end

  private

  def calculate_hour(total_minutes)
    total_minutes / 60 % 24
  end 

  def calculate_minute(total_minutes)
    total_minutes % 60
  end
end