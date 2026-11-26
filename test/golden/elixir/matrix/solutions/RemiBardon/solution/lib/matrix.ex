defmodule Matrix do
  @enforce_keys [:rows]
  defstruct [:rows]

  @doc """
  Convert an `input` string, with rows separated by newlines and values
  separated by single spaces, into a `Matrix` struct.
  """
  @spec from_string(input :: String.t()) :: %Matrix{}
  def from_string(input) do
    rows =
      String.split(input, "\n")
      |> Enum.map(fn line ->
        String.split(line, " ")
        |> Enum.map(&String.to_integer/1)
      end)

    %Matrix{rows: rows}
  end

  @doc """
  Write the `matrix` out as a string, with rows separated by newlines and
  values separated by single spaces.
  """
  @spec to_string(matrix :: %Matrix{}) :: String.t()
  def to_string(%Matrix{} = matrix) do
    rows(matrix)
    |> Enum.map_join("\n", &Enum.join(&1, " "))
  end

  @doc """
  Given a `matrix`, return its rows as a list of lists of integers.
  """
  @spec rows(matrix :: %Matrix{}) :: list(list(integer))
  def rows(%Matrix{rows: rows}), do: rows

  @doc """
  Given a `matrix` and `index`, return the row at `index`.
  """
  @spec row(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def row(%Matrix{rows: rows}, index), do: Enum.at(rows, index - 1)

  @doc """
  Given a `matrix`, return its columns as a list of lists of integers.
  """
  @spec columns(matrix :: %Matrix{}) :: list(list(integer))
  def columns(%Matrix{rows: rows} = matrix) do
    column_count = Enum.count(Enum.at(rows, 0))
    Enum.map(1..column_count, &column(matrix, &1))
  end

  @doc """
  Given a `matrix` and `index`, return the column at `index`.
  """
  @spec column(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def column(%Matrix{rows: rows}, index) do
    Enum.map(rows, &Enum.at(&1, index - 1))
  end
end
