# To Do: Define the class JuiceMaker
class JuiceMaker
  def initialize(fluid : Int32)
    @running = false
    @fluid = fluid
  end
  
  def JuiceMaker.debug_light_on?
    true
  end

  def start
    @running = true
  end
  def running?
    @running
  end
  def add_fluid(fluid : Int32)
    @fluid += fluid
  end
  def stop(min : Int32)
    @running = false
    @fluid -= min * 5
  end
end

