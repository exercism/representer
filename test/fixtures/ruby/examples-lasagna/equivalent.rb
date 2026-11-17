# Keyword parameter names stay, because callers use them. That keeps
# actual_minutes_in_oven everywhere, since renaming goes by name.
class Pasta
  OVEN_MINUTES = 40
  MINUTES_PER_LAYER = 2

  def remaining(actual_minutes_in_oven) = OVEN_MINUTES - actual_minutes_in_oven

  def prep_time(count)
    count * MINUTES_PER_LAYER
  end

  def total(number_of_layers:, actual_minutes_in_oven:) = prep_time(number_of_layers) + actual_minutes_in_oven
end
