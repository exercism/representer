# To Do: Define the class JuiceMaker
class JuiceMaker
  def initialize(@fluid : Int32)
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

  def stop(min)
    @running = false
    @fluid -= (min*5)
  end
end