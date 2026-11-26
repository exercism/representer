class JuiceMaker
  @running = false

  @fluid : Int32

  def initialize(fluid : Int32)
    @fluid = fluid
  end

  def start
    @running = true
  end

  def running?
    @running
  end

  def add_fluid(amount)
    @fluid = @fluid + amount
  end

  def stop(time)
    @running = false
    @fluid = @fluid - (5 * time)
  end

  def self.debug_light_on?
    true
  end
end
