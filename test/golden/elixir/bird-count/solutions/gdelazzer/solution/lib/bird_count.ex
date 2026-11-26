defmodule BirdCount do
  def today(list) when length(list) == 0, do: nil
  def today(list), do: hd(list)

  def increment_day_count(list) when length(list) == 0, do: [1]

  def increment_day_count(list) do
    [head | rest] = list
    [head + 1 | rest]
  end

  def has_day_without_birds?(list), do: 0 in list

  def total(list) do
    Enum.reduce(list, 0, fn x, acc -> x + acc end)
  end

  def busy_days(list) do
    Enum.reduce(list, 0, fn x, acc ->
      if x >= 5, do: acc + 1, else: acc
    end)
  end
end
