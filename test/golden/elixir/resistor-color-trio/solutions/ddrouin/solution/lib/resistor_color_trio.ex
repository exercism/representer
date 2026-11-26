defmodule ResistorColorTrio do
  @color_bands %{
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
  Calculate the resistance value in ohms from resistor colors
  """
  @spec label(colors :: [atom]) :: {number, :ohms | :kiloohms | :megaohms | :gigaohms}
  def label(colors) do
    prefix = @color_bands[Enum.at(colors, 0)] * 10 + @color_bands[Enum.at(colors, 1)]
    suffix = String.duplicate("0", @color_bands[Enum.at(colors, 2)])
    value = elem(Integer.parse("#{prefix}#{suffix}"), 0)

    cond do
      value < 1_000 -> {value, :ohms}
      value < 1_000_000 -> {div(value, 1_000), :kiloohms}
      value < 1_000_000_000 -> {div(value, 1_000_000), :megaohms}
      true -> {div(value, 1_000_000_000), :gigaohms}
    end
  end
end
