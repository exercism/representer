defmodule ETL do
  @doc """
  Transforms an old Scrabble score system to a new one.

  ## Examples

    iex> ETL.transform(%{1 => ["A", "E"], 2 => ["D", "G"]})
    %{"a" => 1, "d" => 2, "e" => 1, "g" => 2}
  """
  @spec transform(map) :: map
  def transform(input) do
    input
    |> Enum.map(fn {k, x} -> list_to_map(x, k) end)
    |> Enum.reduce(%{}, &Map.merge/2)
  end

  defp list_to_map(list, value) do
    list
    |> Enum.map(&String.downcase/1)
    |> Enum.reduce(%{}, fn x, acc -> Map.put(acc, x, value) end)
  end
end
