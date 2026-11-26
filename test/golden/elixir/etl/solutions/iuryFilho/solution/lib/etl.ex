defmodule ETL do
  @doc """
  Transforms an old Scrabble score system to a new one.

  ## Examples

    iex> ETL.transform(%{1 => ["A", "E"], 2 => ["D", "G"]})
    %{"a" => 1, "d" => 2, "e" => 1, "g" => 2}
  """
  @spec transform(map) :: map
  def transform(input) do
    f = fn {point, letters}, acc ->
      letters
      |> Enum.reduce(acc, &Map.put(&2, String.downcase(&1), point))
    end
    Enum.reduce(input, %{}, f)
  end
end
