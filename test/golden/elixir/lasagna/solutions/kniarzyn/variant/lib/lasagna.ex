defmodule Lasagna do
  # TODO: define the 'expected_minutes_in_oven/0' function
  def expected_minutes_in_oven(), do: 40

  # TODO: define the 'remaining_minutes_in_oven/1' function
  @spec remaining_minutes_in_oven(already_in_time :: Integer.t()) :: Integer.t()
  def remaining_minutes_in_oven(already_in_time) do
    expected_minutes_in_oven() - already_in_time
  end

  # TODO: define the 'preparation_time_in_minutes/1' function
  @spec preparation_time_in_minutes(layers :: Integer.t()) :: Integer.t()
  def preparation_time_in_minutes(layers), do: layers * 2

  # TODO: define the 'total_time_in_minutes/2' function
  @spec total_time_in_minutes(layers :: Integer.t(), minutes_in_oven :: Integer.t()) ::
          Integer.t()
  def total_time_in_minutes(layers, minutes_in_oven) do
    preparation_time_in_minutes(layers) - minutes_in_oven
  end

  # TODO: define the 'alarm/0' function
  def alarm(), do: "Ding!"
end
