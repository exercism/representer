defmodule WineCellar do
  def explain_colors do
    [
      white: "Fermented without skin contact.",
      red: "Fermented with skin contact using dark-colored grapes.",
      rose: "Fermented with some skin contact, but not enough to qualify as a red wine."
    ]
  end

  def filter(cellar, color, opts \\ []) do
    cellar
    |> filter_by_color(color, opts)
    |> maybe_filter(opts, :year, &filter_by_year/2)
    |> maybe_filter(opts, :country, &filter_by_country/2)
  end

  defp filter_by_color(cellar, color, opts) do
    cellar = Enum.filter(cellar, fn {c, _wine} -> c == color end)

    case Keyword.get_values(opts, :color) do
      [] -> cellar
      colors -> cellar |> Enum.filter(fn {c, _wine} -> c in colors end)
    end
    |> Keyword.values()
  end

  defp maybe_filter(cellar, opts, key, fun) do
    case Keyword.get(opts, key) do
      nil -> cellar
      value -> fun.(cellar, value)
    end
  end

  # The functions below do not need to be modified.

  defp filter_by_year(wines, year)
  defp filter_by_year([], _year), do: []

  defp filter_by_year([{_, year, _} = wine | tail], year) do
    [wine | filter_by_year(tail, year)]
  end

  defp filter_by_year([{_, _, _} | tail], year) do
    filter_by_year(tail, year)
  end

  defp filter_by_country(wines, country)
  defp filter_by_country([], _country), do: []

  defp filter_by_country([{_, _, country} = wine | tail], country) do
    [wine | filter_by_country(tail, country)]
  end

  defp filter_by_country([{_, _, _} | tail], country) do
    filter_by_country(tail, country)
  end
end
