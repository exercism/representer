defmodule CollatzConjecture do
  @moduledoc """
  Collatz Conjecture, assuming his conjecture is true.
  """

  @doc """
  calc/1 takes an integer and returns the number of steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """
  @spec calc(input :: pos_integer()) :: non_neg_integer()
  def calc(input) when is_integer(input) and input > 0, do: collatz(input, 0)

  # Recursive function to count the steps to 1, another option might have been Enum.reduce_while/3
  defp collatz(1, steps), do: steps
  defp collatz(input, steps) when rem(input, 2) == 0, do: collatz(div(input, 2), steps + 1)
  defp collatz(input, steps), do: collatz(input * 3 + 1, steps + 1)
end
