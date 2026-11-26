class Clock
  getter minutes : Int32
  def initialize(hour = 0, minute = 0)
    @minutes = (minute + hour*60) % 1440
  end

  def +(other : Clock)
    Clock.new(minute: @minutes + other.minutes)
  end

  def -(other : Clock)
    Clock.new(minute: @minutes - other.minutes)
  end

  def ==(other : Clock)
    @minutes == other.minutes
  end

  def to_s
    hours = ((@minutes / 60).to_i).to_s(precision: 2)
    minutes = (@minutes % 60).to_s(precision: 2)
    "#{hours}:#{minutes}"
  end
end
