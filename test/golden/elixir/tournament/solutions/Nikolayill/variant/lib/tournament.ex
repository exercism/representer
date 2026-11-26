defmodule Tournament do
  @points %{
    "win" => {{1, 1, 0, 0, 3}, {1, 0, 0, 1, 0}},
    "draw" => {{1, 0, 1, 0, 1}, {1, 0, 1, 0, 1}},
    "loss" => {{1, 0, 0, 1, 0}, {1, 1, 0, 0, 3}}
  }

  defp format_row({team, res}) do
    {mp, w, d, l, p} =
      res
      |> Tuple.to_list()
      |> Enum.map(&(Integer.to_string(&1) |> String.pad_leading(2)))
      |> List.to_tuple()

    format_row(team, mp, w, d, l, p)
  end

  defp format_row(team, mp, w, d, l, p) do
    "#{String.pad_trailing(team, 31)}| #{mp} | #{w} | #{d} | #{l} | #{p}"
  end

  defp map_row(first, second, result) do
    case Map.get(@points, result) do
      {first_result, second_result} ->
        [
          {first, first_result},
          {second, second_result}
        ]

      _ ->
        []
    end
  end

  defp parse(input) do
    case String.split(input, ";") do
      [first, second, result] -> map_row(first, second, result)
      _ -> []
    end
  end

  defp sum_results(acc, res) do
    Enum.zip_with(Tuple.to_list(acc), Tuple.to_list(res), &+/2)
    |> List.to_tuple()
  end

  defp update({team, res}, result_map),
    do: Map.update(result_map, team, res, &sum_results(res, &1))

  defp compare({_, {_, _, _, _, p1}}, {_, {_, _, _, _, p2}})
       when is_integer(p1) and is_integer(p2),
       do: p1 >= p2

  defp compare(_, _), do: true

  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    result_table =
      input
      |> Enum.flat_map(&parse/1)
      |> Enum.reduce(%{}, &update/2)
      |> Map.to_list()
      |> Enum.sort(&compare*2)
      |> Enum.map(&format_row/1)

    [format_row("Team", "MP", " W", " D", " L", " P") | result_table]
    |> Enum.join("\n")
  end
end
