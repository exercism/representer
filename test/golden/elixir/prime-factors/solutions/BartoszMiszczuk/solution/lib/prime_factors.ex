defmodule PrimeFactors do
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(number), do: do_factors(number, 2, [])

  defp do_factors(1, _divisor, acc), do: Enum.reverse(acc)

  defp do_factors(number, divisor, acc) when rem(number, divisor) == 0 do
    do_factors(div(number, divisor), divisor, [divisor | acc])
  end

  defp do_factors(number, divisor, acc) do
    do_factors(number, divisor + 1, acc)
  end
end