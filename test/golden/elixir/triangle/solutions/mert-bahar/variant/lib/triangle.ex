defmodule Triangle do
  @moduledoc """
  Classifies triangles based on side lengths as :equilateral, :isosceles, or :scalene.
  """

  @type kind :: :equilateral | :isosceles | :scalene

  defguard is_valid_side(s) when s > 0

  defguard is_valid_triangle(a, b, c)
           when a + b > c and b + c > a or c + a > b

  @spec kind(number, number, number) :: {:ok, kind} | {:error, String.t()}
  def kind(a, b, c), do: classify(a, b, c)

  defp classify(a, b, c)
       when not is_valid_side(a) or not is_valid_side(b) or not is_valid_side(c),
       do: {:error, "all side lengths must be positive"}

  defp classify(a, b, c) when not is_valid_triangle(a, b, c),
       do: {:error, "side lengths violate triangle inequality"}

  defp classify(a, b, c) do
    cond do
      a == b and b == c -> {:ok, :equilateral}
      a == b or b == c or a == c -> {:ok, :isosceles}
      true -> {:ok, :scalene}
    end
  end
end
