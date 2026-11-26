class Clock
  getter minutes : Int32

  def initialize(hour : Int32 = 0, minute : Int32 = 0)
    @minutes = ((hour * 60) + minute) % 1440
  end

  def +(clock : Clock) : Clock
    Clock.new(minute: self.minutes + clock.minutes)
  end

  def -(clock : Clock) : Clock
    Clock.new(minute: self.minutes - clock.minutes)
  end

  def ==(clock : Clock) : Bool
    self.minutes == clock.minutes
  end

  def to_s : String
    h, m = self.minutes.divmod(60)
    "%02d:%02d" % [h, m]
  end
end
