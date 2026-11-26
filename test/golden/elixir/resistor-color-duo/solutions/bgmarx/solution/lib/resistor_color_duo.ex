defmodule ResistorColorDuo do
  @doc """
  Calculate a resistance value from two colors
  """
  @spec value(colors :: [atom]) :: integer
  @key [black: 0, brown: 1, red: 2, orange: 3, yellow: 4, green: 5, blue: 6, violet: 7, grey: 8, white: 9]
  def value(colors) do
    [a, b|_t] = colors
    "#{Keyword.fetch!(@key, a)}#{Keyword.fetch!(@key, b)}" |> String.to_integer()
  end
end
