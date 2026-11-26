defmodule CollatzConjecture do
  @doc """
  calc/1 takes an integer and returns the number of steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """
  @spec calc(input :: pos_integer()) :: non_neg_integer()
  def calc(input) when is_integer(input) and input > 0 do
     steps(input, 0)
  end
  defp steps(1, step) do
    step
  end

  defp steps(input, step) when rem(input, 2) == 0 do
      steps(div(input, 2), step + 1)
  end

  defp steps(input, step) do
    steps(input * 3 + 1, step + 1)
  end

end
