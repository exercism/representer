class Lasagna
  EXPECTED_MINUTES_IN_OVEN = 40
  COOK_TIME_PER_LAYER = 2
  
  def remaining_minutes_in_oven(actual_minutes_in_oven)
    EXPECTED_MINUTES_IN_OVEN - actual_minutes_in_oven
  end

  def preparation_time_in_minutes(layers)
    layers * COOK_TIME_PER_LAYER
  end

  def total_time_in_minutes(number_of_layers: 3, actual_minutes_in_oven: 20)
    preparation_time_in_minutes(number_of_layers) + actual_minutes_in_oven
  end
end
