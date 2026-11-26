class JuiceMaker
  UNITS_OF_JUICE_PER_MINUTE = 5

  def self.debug_light_on?
    true
  end

  def initialize(fluid : Int32)
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

  def stop(minutes_running)
    @running = false
    juice_in_the_cup = minutes_running * UNITS_OF_JUICE_PER_MINUTE
    @fluid -= juice_in_the_cup
    juice_in_the_cup
  end
end
