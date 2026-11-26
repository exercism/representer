defmodule Queens do
  @type t :: %Queens{black: {integer, integer}, white: {integer, integer}}
  defstruct [:white, :black]

  @doc """
  Creates a new set of Queens
  """
  @spec new(Keyword.t()) :: Queens.t()
  def new(opts \\ []) do
    Keyword.keys(opts)
    white = Keyword.get(opts, :white) |> check_on_board()
    black = Keyword.get(opts, :black) |> check_on_board()

    opts
    |> Keyword.drop([:white, :black])
    |> length()
    |> then(fn x -> if x >= 1, do: raise(ArgumentError) end)

    %{
      white: white,
      black: black
    }
    |> check_not_same_square()
  end

  defp check_not_same_square(%{white: white, black: black}) when white == black,
    do: raise(ArgumentError)

  defp check_not_same_square(state), do: state

  defp check_on_board(nil), do: nil
  defp check_on_board(pos = {a, b}) when a >= 0 and a <= 7 and b >= 0 and b <= 7, do: pos
  defp check_on_board(_pos), do: raise(ArgumentError)

  @doc """
  Gives a string representation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(queens) do
    for row <- 0..7 do
      for col <- 0..7 do
        cond do
          {row, col} == queens[:white] -> "W "
          {row, col} == queens[:black] -> "B "
          true -> "_ "
        end
      end
      |> Enum.join()
    end
    |> Enum.join("\n")
    |> String.replace(" \n", "\n")
    |> String.replace(~r/ $/, "")
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(queens) do
    %{queens: queens, status: false}
    |> check_row_and_col()
    |> check_diags()
    |> Map.get(:status)
  end

  defp check_row_and_col(
         state = %{queens: %{black: {rowb, colb}, white: {roww, colw}}, status: _status}
       )
       when rowb == roww or colb == colw,
       do: %{state | status: true}

  defp check_row_and_col(state), do: state

  defp check_diags(state = %{queens: %{black: {rowb, colb}, white: {roww, colw}}})
       when rowb == nil or colb == nil or roww == nil or colw == nil,
       do: state

  defp check_diags(state = %{queens: %{black: {rowb, _colb}, white: {roww, _colw}}})
       when roww == rowb,
       do: state

  defp check_diags(
         state = %{queens: %{black: {rowb, colb}, white: {roww, colw}}, status: _status}
       ) do
    slope = (colw - colb) / (roww - rowb)

    cond do
      slope == 1 or slope == -1 -> %{state | status: true}
      true -> state
    end
  end

  defp check_diags(state), do: state
end
