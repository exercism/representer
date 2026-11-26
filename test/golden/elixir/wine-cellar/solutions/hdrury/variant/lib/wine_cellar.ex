defmodule WineCellar do
  def explain_colors do
    [
      white: "Fermented without skin contact.",
      red: "Fermented with skin contact using dark-colored grapes.",
      rose: "Fermented with some skin contact, but not enough to qualify as a red wine."
    ]
  end

  def map(cellar, color, opts \\ []) do
    Keyword.get_values(cellar, color)
    |> get_by_option(year: Keyword.get(opts, :year))
    |> get_by_option(country: Keyword.get(opts, :country))
  end

  def get_by_option(cellar, year: year) do
    case year do
      nil -> cellar
      _ -> filter_by_year(cellar, year)
    end
  end

  def get_by_option(cellar, country: country) do
    case country do
      nil -> cellar
      _ -> filter_by_country(cellar, country)
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
