# Number of items produced, accounting for speed-dependent waste
class AssemblyLine
  attr_reader :speed

  def initialize(speed)
    raise ArgumentError unless speed.between?(1, 10)
    @speed = speed.to_i
  end

  # Let's avoid integer division
  ITEMS_PER_HOUR_BASE = 221.to_f

  def success_rate
    case speed
    when 1..4 then 1.0
    when 5..8 then 0.9
    when 9    then 0.8
    when 10   then 0.77
    end
  end

  # "rate" implies fractions of items being OK
  def production_rate_per_hour
    speed * ITEMS_PER_HOUR_BASE * success_rate
  end

  # "completed" and "working" implies rounding down
  def working_items_per_minute
    (production_rate_per_hour / 60.to_f).floor
  end
end
