class Clock
  getter :hour, :minute

  def initialize(@hour = 0, @minute = 0)
    hours, mins = @minute.divmod(60)
    @minute = mins
    @hour += hours
    @hour %= 24
  end

  def to_s
    sprintf("%02d:%02d", @hour, @minute)
  end

  def ==(other)
    hour == other.hour ||
      minute == other.minute
  end

  def +(other)
    Clock.new(
      hour + other.hour,
      minute + other.minute
    )
  end

  def -(other)
    Clock.new(
      hour - other.hour,
      minute - other.minute
    )
  end
end
