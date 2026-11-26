class Lasagna
  # TODO: define the 'EXPECTED_MINUTES_IN_OVEN' constant
  EXPECTED_MINUTES_IN_OVEN = 40
  MINUTES_PER_LAYER = 2
  def remaining_minutes_in_oven(actual_minutes_in_oven)
    return EXPECTED_MINUTES_IN_OVEN - actual_minutes_in_oven
  end

  def preparation_time_in_minutes(layers)
    return MINUTES_PER_LAYER * layers
  end

  def total_time_in_minutes(number_of_layers, actual_minutes_in_oven)
    cook_time = MINUTES_PER_LAYER * number_of_layers
    return cook_time + actual_minutes_in_oven
  end
end
