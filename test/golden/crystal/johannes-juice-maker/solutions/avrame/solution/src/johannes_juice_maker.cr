class JuiceMaker
  JUICE_PER_MINUTE = 5
  @running = false

  def initialize(@fluid : Int32)
  end

  def self.debug_light_on?
    true
  end

  def start
    @running = true
  end

  def stop(minutes)
    @running = false
    @fluid -= minutes * JUICE_PER_MINUTE
  end

  def running?
    @running
  end

  def add_fluid(fluid)
    @fluid += fluid
  end
end
