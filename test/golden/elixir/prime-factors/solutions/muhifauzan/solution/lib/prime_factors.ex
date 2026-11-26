defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(number) do
    factors_reducer(number, 2, [])
  end

  ## Privates

  defp factors_reducer(1, _x, acc) do
    Enum.reverse(acc)
  end

  defp factors_reducer(number, x, acc) when rem(number, x) == 0 do
    factors_reducer(div(number, x), x, [x | acc])
  end

  defp factors_reducer(number, x, acc) do
    factors_reducer(number, x + 1, acc)
  end
end
