class JuiceMaker
  def initialize(fluid : Int32)
    @running = false
    @fluid = fluid
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

  def add_fluid(more_juice)
    @fluid += more_juice
  end

  def stop(running_duration : Int32)
    juice_consumed = 5 * running_duration
    if juice_consumed > @fluid
      juice_consumed = @fluid
    end
    @fluid -= juice_consumed
    @running = false
    self
  end
end
