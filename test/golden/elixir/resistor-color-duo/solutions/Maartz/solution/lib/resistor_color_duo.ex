defmodule ResistorColorDuo do
  @colors_resistance_map %{
    black: 0,
    brown: 1,
    red: 2,
    orange: 3,
    yellow: 4,
    green: 5,
    blue: 6,
    violet: 7,
    grey: 8,
    white: 9
  }
  @doc """
  Calculate a resistance value from two colors
  """
  @spec value(colors :: [atom]) :: integer
  def value([first_band, second_band | _]), do: @colors_resistance_map[first_band] * 10 + @colors_resistance_map[second_band]
end
