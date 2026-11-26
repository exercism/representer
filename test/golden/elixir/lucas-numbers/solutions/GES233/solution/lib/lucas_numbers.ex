defmodule LucasNumbers do
  @moduledoc """
  Lucas numbers are an infinite sequence of numbers which build progressively
  which hold a strong correlation to the golden ratio (φ or ϕ)

  E.g.: 2, 1, 3, 4, 7, 11, 18, 29, ...
  """
  def generate(count) when is_integer(count) do
    if count >= 1 do
      Stream.iterate({2, 1}, &do_generate/1)
      |> Enum.take(count)
      |> Enum.map(fn {a, _} -> a end)
    else
      generate(nil)
    end
  end
  def generate(_) do
    raise ArgumentError, "count must be specified as an integer >= 1"
  end

  defp do_generate({pprev, prev}), do: {prev, pprev + prev}
end
