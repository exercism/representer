class Lasagna

  EXPECTED_MINUTES_IN_OVEN = 40 
  
  def remaining_minutes_in_oven(actual_minutes_in_oven)
   return 40 - actual_minutes_in_oven.to_i
  end

  def preparation_time_in_minutes(layers)
    return layers.to_i * 2 
  end

  def total_time_in_minutes(number_of_layers:, actual_minutes_in_oven:)
    return number_of_layers.to_i * 2 + actual_minutes_in_oven.to_i
  end
end
