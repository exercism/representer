# To Do: Define the class JuiceMaker
class JuiceMaker
  @running = false
  @fluid = 0

  def initialize(fluid)
    @fluid = fluid
  end

  def start()
    @running = true
  end

  def running?()
    @running
  end

  def add_fluid(fluid)
    @fluid += fluid
  end

  def stop(min)
    @running = false
    return add_fluid(min * (-5))
  end
  
  def self.debug_light_on?()
    true
  end
end