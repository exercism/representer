defmodule Darts do
  @type position :: {number, number}
  @inner_circle_radious 1
  @middle_circle_radious 5
  @outher_circle_radious 10

  @doc """
  Calculate the score of a single dart hitting a target
  """
  @spec score(position) :: integer
  def score({x, y}) do
    cond do
      inside_radious?({x, y}, 1) -> 10
      inside_radious?({x, y}, 5) -> 5
      inside_radious?({x, y}, 10) -> 1
      true -> 0
    end
  end

  defp inside_radious?({x, y}, radious) do
    (x**2 + y**2) <= radious**2
  end
end
