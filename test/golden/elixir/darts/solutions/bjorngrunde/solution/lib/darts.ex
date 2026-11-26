defmodule Darts do
  @type position :: {number, number}

  @doc """
  Calculate the score of a single dart hitting a target
  """
  @spec score(position) :: integer
  def score({x, y}) do
    num = :math.sqrt(x * x + y * y)

    cond do
      num <= 1 -> 10
      num <= 5 -> 5
      num <= 10 -> 1
      true -> 0
    end
  end
end
