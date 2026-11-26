
defmodule Lasagna do
  def expected_minutes_in_oven(), do: 40
  def remaining_minutes_in_oven(minutes_already_in_oven),
    do: expected_minutes_in_oven() - minutes_already_in_oven
  def preparation_time_in_minutes(lasagna_layers), do: lasagna_layers * 2
  def total_time_in_minutes(lasagna_layers, minutes_already_in_oven),
    do: preparation_time_in_minutes(lasagna_layers) + minutes_already_in_oven
  def alarm(), do: "Ding!"
end