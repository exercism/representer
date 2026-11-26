class JuiceMaker
  def initialize(volume : Int32)
    @running = false
    @fluid = volume
  end

  def running?
    !!@running
  end

  def start
    @running = true
  end

  def stop(duration_in_minutes)
    @running = false
    @fluid -= duration_in_minutes * UNITS_PER_MINUTE
  end

  def add_fluid(volume)
    @fluid += volume
  end

  def self.debug_light_on?
    true
  end

  UNITS_PER_MINUTE = 5
end
