defmodule Proverb do
  @doc """
  Generate a proverb from a list of strings.
  """
  @spec recite(strings :: [String.t()]) :: String.t()
  def recite([]), do: ""
  def recite(strings) do
    for_want_lines = strings
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> "For want of a #{a} the #{b} was lost.\n" end)
      |> Enum.join("")
    "#{for_want_lines}And all for the want of a #{Enum.at(strings, 0)}.\n"
  end
end
