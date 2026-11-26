defmodule KillerSudokuHelper do
  @doc """
  Return the possible combinations of `size` distinct numbers from 1-9 excluding `exclude` that sum up to `sum`.
  """
  @spec combinations(cage :: %{exclude: [integer], size: integer, sum: integer}) :: [[integer]]
  def combinations(%{exclude: exclude, size: size, sum: sum}) do
    [1, 2, 3, 4, 5, 6, 7, 8, 9] -- exclude
    |> do_combinations(size, [[]])
    |> Enum.filter(fn c -> Enum.sum(c) == sum end)
    |> Enum.map(&Enum.sort/1)
  end

  defp do_combinations(_, 0, list), do: list

  defp do_combinations(numbers, size, list) do
    numbers
    |> List.duplicate(length(numbers))
    |> Enum.with_index
    |> Enum.map(fn {n, i} -> Enum.drop(n, i) end)
    |> Enum.map(fn [head | tail] -> do_combinations(tail, size - 1, Enum.map(list, &[head | &1])) end)
    |> Enum.concat
  end

end
