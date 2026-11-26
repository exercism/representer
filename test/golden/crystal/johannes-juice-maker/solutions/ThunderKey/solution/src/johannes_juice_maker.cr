class JuiceMaker
  def self.debug_light_on?
    true
  end

  def initialize(@fluid : Int32)
    @running = false
  end

  def start
    @running = true
  end

  def stop(minutes)
    @running = false
    @fluid -= minutes * 5
  end

  def running?
    @running
  end

  def add_fluid(fluid)
    @fluid += fluid
  end
end