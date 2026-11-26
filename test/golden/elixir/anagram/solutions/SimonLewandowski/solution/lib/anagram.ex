defmodule Anagram do
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    base_down = String.downcase(base)
    sorted_base = sort_string(base_down)

    Enum.filter(candidates, fn word ->
      word_down = String.downcase(word)
      word_down != base_down and sort_string(word_down) == sorted_base
    end)
  end

  defp sort_string(str) do
    str
    |> String.graphemes()
    |> Enum.sort()
  end
end
