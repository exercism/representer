defmodule KillerSudokuHelper do
  @doc """
  Return the possible combinations of `size` distinct numbers from 1-9 excluding `exclude` that sum up to `sum`.
  """
  @spec combinations(cage :: %{exclude: [integer], size: integer, sum: integer}) :: [[integer]]
  def combinations(cage) do
    1..9
    |> get_numbers(cage.exclude)
    |> get_combos(cage.size)
    |> filter_by_sum(cage.sum)
  end

  defp get_numbers(range, exclude), do: Enum.reject(range, &Enum.member?(exclude, &1))

  defp get_combos(_, 0), do: [[]]
  defp get_combos([], _), do: []

  defp get_combos([head | tail], size) do
    for(l <- get_combos(tail, size - 1), do: [head | l]) ++ get_combos(tail, size)
  end

  defp filter_by_sum(combos, sum) do
    Enum.filter(combos, fn combo -> Enum.sum(combo) === sum end)
  end
end
