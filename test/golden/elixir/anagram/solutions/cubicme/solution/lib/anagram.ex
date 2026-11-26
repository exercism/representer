defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    sorted_base = sorted_chars(base)
    candidates
    |> Enum.filter(fn str -> sorted_chars(str) == sorted_base and not same_word?(str, base) end)
  end

  defp sorted_chars(str) do
    str
    |> String.downcase
    |> String.graphemes
    |> Enum.sort
  end

  defp same_word?(a, b), do: String.downcase(a) == String.downcase(b)
end
