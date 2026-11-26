class JuiceMaker
  @fluid : Int32
  @running : Bool

  def initialize(fluid)
    @fluid = fluid
    @running = false
  end

  def self.debug_light_on?
    true
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

  def stop(minutes)
    @fluid = Math.max(0, @fluid - 5 * minutes)
    @running = false
  end
end
