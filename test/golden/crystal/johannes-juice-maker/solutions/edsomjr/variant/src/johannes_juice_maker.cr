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

  def add_fluid(amount)
    @fluid += amount
  end

  def stop(time_in_minutes)
    @running = false
    @fluid = Math.max(@fluid - 5/time_in_minutes, 0)
  end

end
