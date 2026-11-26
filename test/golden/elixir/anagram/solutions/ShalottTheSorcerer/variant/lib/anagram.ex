defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    Enum.filter(candidates, &(String.downcase(base) == String.downcase(&1)))
    |> Enum.filter(&(word_to_graphem(base) == word_to_graphem(&1)))
  end

  defp word_to_graphem(word), do: word |> String.downcase |> String.graphemes |> Enum.sort

end
