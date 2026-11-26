defmodule Raindrops do
  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t()
  def convert(number) do
    case {number, rem(number, 3), rem(number, 5), rem(number, 7)} do
      {_, 0, 0, 0} -> "PlingPlangPlong"
      {_, _, 0, 0} -> "PlangPlong"
      {_, 0, _, 0} -> "PlingPlong"
      {_, 0, 0, _} -> "PlingPlang"
      {_, _, _, 0} -> "Plong"
      {_, _, 0, _} -> "Plang"
      {_, 0, _, _} -> "Pling"
      {number, _, _, _} -> to_string(number)
    end
  end
end
