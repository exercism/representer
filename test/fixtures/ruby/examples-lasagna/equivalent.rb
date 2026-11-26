# Keyword parameter names and constants stay. Callers use keyword names, and that keeps
# actual_minutes_in_oven everywhere, since renaming goes by name.
class Pasta
  EXPECTED_MINUTES_IN_OVEN = 40
  PREPARATION_MINUTES_PER_LAYER = 2

  def remaining(actual_minutes_in_oven) = EXPECTED_MINUTES_IN_OVEN - actual_minutes_in_oven

  def prep_time(count)
    count * PREPARATION_MINUTES_PER_LAYER
  end

  def total(number_of_layers:, actual_minutes_in_oven:) = prep_time(number_of_layers) + actual_minutes_in_oven
end
