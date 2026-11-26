class AssemblyLine
  def initialize(speed)
    @speed = speed
  end

  def cars_per_hour
    @speed * 221.0
  end

  def success_rate
    case @speed
    when 1..4
      1.0
    when 5..8
      0.9
    when 9
      0.8
    when 10
      0.77
    else 
      raise ArgumentError.new("Expected a speed value of 1-10, got #{speed}")
    end
  end

  def production_rate_per_hour
    (success_rate * cars_per_hour).round(1)
  end

  def working_items_per_minute
    (production_rate_per_hour / 60).to_i
  end
end
