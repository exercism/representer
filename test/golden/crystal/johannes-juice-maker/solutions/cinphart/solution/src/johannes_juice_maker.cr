class JuiceMaker
  def initialize(amount_of_juice : Int32)
    @running = false
    @fluid = amount_of_juice
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

  def add_fluid(fluid : Int32)
    @fluid += fluid
  end

  def stop(minutes : Int32)
    @running = false
    @fluid -= minutes * 5
    @fluid
  end
  
end
