defmodule Hamming do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance('AAGTCATA', 'TAGCGATC')
  {:ok, 4}
  """
  @spec hamming_distance([char], [char]) :: {:ok, non_neg_integer} | {:error, String.t()}
  def hamming_distance(strand1, strand2) when length(strand1) == length(strand2) do
    do_ham(strand1, strand2)
  end

  def hamming_distance(_strand1, _strand2), do: {:error, "strands must be of equal length"}

  defp do_ham(strand1, strand2, count \\ 0)
  defp do_ham([], [], count), do: {:ok, count}
  defp do_ham([h1|t1], [h2|t2], count) do
    count = if h1 != h2, do: count + 1, else: count
    do_ham(t1, t2, count)
  end
end
