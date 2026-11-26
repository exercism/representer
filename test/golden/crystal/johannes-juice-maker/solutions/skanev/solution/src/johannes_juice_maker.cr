class JuiceMaker
  @fluid : Int64
  @running : Bool

  def self.debug_light_on?
    true
  end

  def initialize(fluid)
    @fluid = fluid
    @running = false
  end

  def start
    @running = true
  end

  def running?
    @running
  end

  def add_fluid(fluid)
    @fluid += fluid
  end

  def stop(minutes) : Int64
    @running = false
    @fluid -= minutes * 5
  end
end
