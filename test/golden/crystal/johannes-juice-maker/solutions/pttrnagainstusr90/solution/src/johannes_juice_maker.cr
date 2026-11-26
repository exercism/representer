# To Do: Define the class JuiceMaker
class JuiceMaker

  def self.debug_light_on?
    true
  end

  def initialize(fluid : Int32)
    @running = false
    @fluid = fluid
  end

  def start()
    @running = true
  end

  def running?
    @running
  end

  def add_fluid(amount)
    @fluid += amount
  end

  def stop(time)
    @fluid -= time * 5
    @running = false
  end
end
  
  