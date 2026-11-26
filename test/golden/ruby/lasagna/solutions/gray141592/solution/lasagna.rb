class Lasagna
  EXPECTED_MINUTES_IN_OVEN = 40;
  PREPARATION_TIME_BY_LAYER = 2;
  def remaining_minutes_in_oven(actual_minutes_in_oven)
    remaining_minutes_in_oven = EXPECTED_MINUTES_IN_OVEN - actual_minutes_in_oven;
    return remaining_minutes_in_oven > 0 ? remaining_minutes_in_oven : 0;
  end

  def preparation_time_in_minutes(layers)
    return layers * PREPARATION_TIME_BY_LAYER;
  end

  def total_time_in_minutes(number_of_layers:, actual_minutes_in_oven:)
    return actual_minutes_in_oven + self.preparation_time_in_minutes(number_of_layers);
  end
end
