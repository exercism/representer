class Lasagna

  EXPECTED_MINUTES_IN_OVEN = 40
  TIME_PER_LAYER = 2
  
  def remaining_minutes_in_oven(actual_minutes_in_oven)
     validate(actual_minutes_in_oven)
     EXPECTED_MINUTES_IN_OVEN - actual_minutes_in_oven
  end

  def preparation_time_in_minutes(layers)
    validate(layers)
    TIME_PER_LAYER * layers
  end

  def total_time_in_minutes(number_of_layers:, actual_minutes_in_oven:)
    validate(actual_minutes_in_oven)
    preparation_time_in_minutes(number_of_layers) + actual_minutes_in_oven
  end

  private

  def validate(min)
    raise 'minute should be numeric value' unless min.is_a? Numeric
    raise 'minute should be positive number' unless min.positive?
    true
  end
end
