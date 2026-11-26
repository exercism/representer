defmodule Hamming do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance(~c"AAGTCATA", ~c"TAGCGATC")
  {:ok, 4}
  """
  defguard eq_len(c1, c2) when length(c1) == length(c2)

  @spec hamming_distance([char], [char]) :: {:ok, non_neg_integer} | {:error, String.t()}
  def hamming_distance(s1, s2) when eq_len(s1, s2) do
    Enum.zip(s1, s2)
    |> Enum.count(fn {first, second} -> first == second end)
    |> dist_count()
  end

  def hamming_distance(_, _), do: {:error, "strands must be of equal length"}

  defp dist_count(count), do: {:ok, count}
end
