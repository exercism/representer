class Clock
  getter minutes : Int32
  private setter minutes : Int32

  def initialize(hour = 0, minute = 0)
    @minutes = (hour * 60 + minute) % (24 * 60)
  end

  def +(other : Clock)
    self.minutes += other.minutes
    self
  end

  def -(other : Clock)
    self.minutes -= other.minutes
    self
  end

  def ==(other : Clock)
    minutes == other.minutes
  end

  def to_s
    "%02i:%02i" % [hour, minute]
  end

  def hour
    (minutes / 60) % 24
  end

  def minute
    minutes % 60
  end
end
