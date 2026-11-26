class JuiceMaker
  def self.debug_light_on?
    true
  end

  def initialize(fluid : Int32)
    @running = false
    @fluid = fluid
  end

  def start
    @running = true
  end

  def stop(time)
    @running = false
    @fluid -= (time * 5)
  end

  def running?
    @running
  end

  def add_fluid(amount)
    @fluid += amount
  end
end
