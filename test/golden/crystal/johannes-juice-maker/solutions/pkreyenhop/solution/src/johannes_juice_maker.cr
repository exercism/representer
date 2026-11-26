class JuiceMaker
  @fluid : Int32

  def self.debug_light_on?
    true
  end

  def initialize(j)
    @running = false
    @fluid = j
  end

  def start
    @running = true
  end

  def running?
    @running
  end

  def add_fluid(f)
    @fluid += f
  end

  def stop(m)
    @running = false
    @fluid = @fluid - (m*5)
  end
end
